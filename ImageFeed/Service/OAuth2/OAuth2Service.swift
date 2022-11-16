//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Filosuf on 10.11.2022.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void)
}

enum NetworkError: Error {
    case responseError
    case decodeError
}

final class OAuth2Service: OAuth2ServiceProtocol {
    
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                completion(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                completion(.failure(NetworkError.responseError))
                return
            }

            // Декодируем полученные данные
            guard let data = data else { return }
            let resultDecoding = self.decoding(data: data)

            switch resultDecoding {
            case .success(let token):
                // Возвращаем данные
                DispatchQueue.main.async {
                    completion(.success(token))
                }
            case .failure(let error):
                completion(.failure(error))
            }

        }
        task.resume()
    }

    private func decoding(data: Data) -> Result<String, Error>{
        do {
            let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            return .success(responseBody.accessToken)
        } catch {
            print("Error decode OAuthTokenResponseBody from data")
            return.failure(NetworkError.decodeError)
        }
    }
}

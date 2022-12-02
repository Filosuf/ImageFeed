//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by Filosuf on 28.11.2022.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
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
            let resultDecoding: Result<T, Error> = self.decoding(data: data)

            switch resultDecoding {
            case .success(let dataDecoded):
                // Возвращаем данные
                completion(.success(dataDecoded))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }

    private func decoding<T: Decodable>(data: Data) -> Result<T, Error>{
        do {
            let responseBody = try JSONDecoder().decode(T.self, from: data)
            return .success(responseBody)
        } catch {
            return.failure(NetworkError.decodeError)
        }
    }
}

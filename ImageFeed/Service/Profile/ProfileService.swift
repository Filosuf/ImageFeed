//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Filosuf on 27.11.2022.
//

import Foundation

final class ProfileService {

    // MARK: - Properties
    static let shared = ProfileService()

    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?

    // MARK: - LifeCycle
    private init() {}

    // MARK: - Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {

        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let url = URL(string: "https://api.unsplash.com/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                self.lastToken = nil
                completion(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                self.lastToken = nil
                completion(.failure(NetworkError.responseError))
                return
            }
            // Декодируем полученные данные
            guard let data = data else { return }
            let resultDecoding = self.decoding(data: data)

            switch resultDecoding {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                // Возвращаем данные
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
            case .failure(let error):
                self.lastToken = nil
                completion(.failure(error))
            }

        }
        self.task = task
        task.resume()
    }

    private func decoding(data: Data) -> Result<ProfileResult, Error>{
        do {
            let responseBody = try JSONDecoder().decode(ProfileResult.self, from: data)
            return .success(responseBody)
        } catch {
            print("Error decode ProfileResult from data")
            return.failure(NetworkError.decodeError)
        }
    }
}

//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Filosuf on 28.11.2022.
//

import Foundation

final class ProfileImageService {
    // MARK: - Properties
    static let shared = ProfileImageService()

    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    // MARK: - LifeCycle
    private init() {}

    // MARK: - Methods
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        let url = URL(string: "https://api.unsplash.com/users/\(username)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                self.lastUsername = nil
                completion(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                self.lastUsername = nil
                completion(.failure(NetworkError.responseError))
                return
            }
            if let response = response as? HTTPURLResponse {
                print("response code = \(response.statusCode)")
            }
            // Декодируем полученные данные
            guard let data = data else { return }
            let resultDecoding = self.decoding(data: data)

            switch resultDecoding {
            case .success(let userResult):
                let smallProfileImage = userResult.profileImage.small
                self.avatarURL = smallProfileImage
                // Возвращаем данные
                DispatchQueue.main.async {
                    completion(.success(smallProfileImage))
                }
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": smallProfileImage])                   
            case .failure(let error):
                self.lastUsername = nil
                completion(.failure(error))
            }

        }
        self.task = task
        task.resume()
    }

    private func decoding(data: Data) -> Result<UserResult, Error>{
        do {
            let responseBody = try JSONDecoder().decode(UserResult.self, from: data)
            print(responseBody)
            return .success(responseBody)
        } catch {
            print("Error decode ProfileResult from data")
            return.failure(NetworkError.decodeError)
        }
    }
}

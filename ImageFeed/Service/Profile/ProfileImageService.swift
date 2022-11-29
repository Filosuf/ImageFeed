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

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let smallProfileImage = model.profileImage.small
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

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

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                let profile = Profile(profileResult: model)
                self.profile = profile
                // Возвращаем данные
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
            case .failure(let error):
                self.lastToken = nil
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Filosuf on 02.12.2022.
//

import UIKit

final class ImagesListService {
    // MARK: - Properties
    static let shared = ImagesListService()

    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private var taskChangeLike: URLSessionTask?
    private var lastLoadedPage: Int?
    private let tokenStorage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    // MARK: - LifeCycle
    private init() {}

    // MARK: - Methods
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1

        assert(Thread.isMainThread)
        task?.cancel()
        guard let token = tokenStorage.token else { return }
        var urlComponents = URLComponents(string: defaultBaseUrl + "/photos")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(nextPage)")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                var nextPagePhotos: [Photo] = []
                for model in models {
                    let photo = Photo(photoResult: model)
                    nextPagePhotos.append(photo)
                }
                DispatchQueue.main.async {
                    self.photos += nextPagePhotos
                    self.lastLoadedPage = nextPage
                }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
            case .failure:
                return
            }
        }
        self.task = task
        task.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        taskChangeLike?.cancel()

        guard let token = tokenStorage.token else { return }
        var url = URL(string: defaultBaseUrl)!
        url.appendPathComponent("photos")
        url.appendPathComponent(photoId)
        url.appendPathComponent("like")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    DispatchQueue.main.async {
                        self.photos[index].isLiked = model.photo.isLiked
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        self.taskChangeLike = task
        task.resume()
    }
}

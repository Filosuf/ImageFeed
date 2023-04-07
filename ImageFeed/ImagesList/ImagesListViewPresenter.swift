//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Filosuf on 20.01.2023.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func fetchPhotosNextPage(row: Int)
    func handleAnswerLike(index: Int)
    func fetchPhoto(index: Int) -> Photo
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    // MARK: - Properties
    var view: ImagesListViewControllerProtocol?
    private let imageListService = ImagesListService.shared
    private var photos = [Photo]()
    var photosCount: Int { photos.count }

    // MARK: - Methods
    func viewDidLoad() {
        imageListService.fetchPhotosNextPage()
        addObserver()
    }

    func fetchPhoto(index: Int) -> Photo {
        photos[index]
    }

    func fetchPhotosNextPage(row: Int) {
        guard row + 1 == photos.count else { return }
        imageListService.fetchPhotosNextPage()
    }

    func handleAnswerLike(index: Int) {
        let photo = photos[index]
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            self.view?.dismissUIBlocking()
            switch result {
            case .success:
                // Синхронизируем массив картинок с сервисом
                self.photos = self.imageListService.photos
                self.view?.updateCell(photo: photo, index: index)
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }

    // MARK: - Private methods
    private func addObserver() {
        NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }

}

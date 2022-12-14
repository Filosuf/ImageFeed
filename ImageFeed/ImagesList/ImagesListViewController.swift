//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by 1234 on 24.09.2022.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    // MARK: - Properties
    private let imageListService = ImagesListService.shared
    private let singleImageIdentifier = "ShowSingleImage"
    private var photosName = [String]()
    private var photos = [Photo]()
    private lazy var alertPresenter = AlertPresenter(viewController: self)

    @IBOutlet private var tableView: UITableView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photosName = Array(0..<20).map{ "\($0)" }
        imageListService.fetchPhotosNextPage()
        addObserver()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == singleImageIdentifier {
                let viewController = segue.destination as! SingleImageViewController
                let indexPath = sender as! IndexPath
                let photo = photos[indexPath.row]
                viewController.fullImageUrl = photo.largeImageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }

    // MARK: - Methods
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
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: singleImageIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == photos.count else { return }
        imageListService.fetchPhotosNextPage()
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.config(photo: photos[indexPath.row],delegate: self)
        return imageListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                // ???????????????????????????? ???????????? ???????????????? ?? ????????????????
                self.photos = self.imageListService.photos
                // ?????????????? ?????????????????? ?????????? ????????????????
                cell.update(photo: self.photos[indexPath.row])
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.alertPresenter.showErrorAlert(message: "??????-???? ?????????? ???? ??????(", action: { })
            }
        }
    }

    func imageLoadingIsFinished(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

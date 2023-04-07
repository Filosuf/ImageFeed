//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by 1234 on 24.09.2022.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol? { get set }

    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func updateCell(photo: Photo, index: Int)
    func showErrorAlert()
    func dismissUIBlocking()
}
final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // MARK: - Properties
    var presenter: ImagesListViewPresenterProtocol?
    private let singleImageIdentifier = "ShowSingleImage"
    private lazy var alertPresenter = AlertPresenter(viewController: self)

    @IBOutlet private var tableView: UITableView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if presenter == nil {
            presenter = ImagesListViewPresenter()
        }
        presenter?.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == singleImageIdentifier {
                let viewController = segue.destination as! SingleImageViewController
                let indexPath = sender as! IndexPath
                let photo = presenter?.fetchPhoto(index: indexPath.row)
                viewController.fullImageUrl = photo?.largeImageURL
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }

    // MARK: - Methods
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: singleImageIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage(row: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell,
              let photo = presenter?.fetchPhoto(index: indexPath.row) else {
                  return UITableViewCell()
              }
        imageListCell.config(photo: photo, delegate: self)
        return imageListCell
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        UIBlockingProgressHUD.show()
        presenter?.handleAnswerLike(index: indexPath.row)
    }

    func updateCell(photo: Photo, index: Int) {
        // Изменим индикацию лайка картинки
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ImagesListCell else { return }
        cell.update(photo: photo)
    }

    func showErrorAlert() {
        alertPresenter.showErrorAlert(message: "Что-то пошло не так(", action: { })
    }

    func dismissUIBlocking() {
        UIBlockingProgressHUD.dismiss()
    }

    func imageLoadingIsFinished(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


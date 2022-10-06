//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by 1234 on 24.09.2022.
//

import UIKit

class ImagesListViewController: UIViewController {

    // MARK: - Properties
    private var photosName = [String]()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photosName = Array(0..<20).map{ "\($0)" }
    }

    // MARK: - Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }

        cell.contentImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        let likeImage = (indexPath.row % 2 == 0) ? UIImage(named: "favorites.fill") : UIImage(named: "favorites")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1

        guard let imageListCell = cell as? ImagesListCell else { // 2
            return UITableViewCell()
        }
         
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell // 4
    }


}

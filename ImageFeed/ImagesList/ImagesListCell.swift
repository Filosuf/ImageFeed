//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by 1234 on 30.09.2022.
//

import UIKit
//import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
    func imageLoadingIsFinished(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var contentImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!

    weak var delegate: ImagesListCellDelegate?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        contentImage.kf.cancelDownloadTask()
    }

    func config(photo: Photo, delegate: ImagesListCellDelegate?) {
        self.delegate = delegate
        let imageURL = photo.thumbImageURL
        guard let url = URL(string: imageURL) else { return }

        contentImage.kf.setImage(with: url, placeholder: UIImage(named: "imagePlaceholder.svg"), options: []) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.imageLoadingIsFinished(self)
            
        }

        if let date = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        }

        let likeImage = photo.isLiked ? UIImage(named: "favorites.fill") : UIImage(named: "favorites")
        likeButton.setImage(likeImage, for: .normal)
    }

    func update(photo: Photo) {
        let likeImage = photo.isLiked ? UIImage(named: "favorites.fill") : UIImage(named: "favorites")
        likeButton.setImage(likeImage, for: .normal)
    }
}

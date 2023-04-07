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

    @IBOutlet private var contentImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    private var animationLayers = [CAGradientLayer]()

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
        selectionStyle = .none
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
        if animationLayers.isEmpty {
            addAnimations()
        }

        contentImage.kf.setImage(with: url, placeholder: UIImage(named: "imagePlaceholder.svg"), options: []) { [weak self] result in
            guard let self = self else { return }
            self.delegate?.imageLoadingIsFinished(self)
            self.removeAnimations()
            
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

    private func addAnimations() {
        let contentImageGradientFrame = CGRect(origin: .zero, size: contentImage.frame.size)
        addGradient(on: contentImage, with: contentImageGradientFrame, cornerRadius: 16)
    }

    private func removeAnimations() {
        for animation in animationLayers {
            animation.removeFromSuperlayer()
        }
    }

    private func addGradient(on view: UIView, with frame: CGRect, cornerRadius: CGFloat? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius ?? frame.height / 2
        gradient.masksToBounds = true
        animationLayers.append(gradient)
        view.layer.addSublayer(gradient)

        let gradientChangeAnimation = CAKeyframeAnimation(keyPath: "locations")

        gradientChangeAnimation.values = [
            [0, 0.1, 0.3],
            [0, 0.8, 1],
            [0, 0.1, 0.3]
        ]
        gradientChangeAnimation.keyTimes = [0, 0.5, 1]
        gradientChangeAnimation.duration = 1
        gradientChangeAnimation.repeatCount = .infinity

        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
}

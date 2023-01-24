//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1234 on 26.10.2022.
//

import UIKit
import Kingfisher


protocol ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateProfileDetails(with profile: Profile?)
    func updateAvatar(with url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    // MARK: - Properties
    var presenter: ProfileViewPresenterProtocol?

    private lazy var alertPresenter = AlertPresenter(viewController: self)
    private var animationLayers = [CAGradientLayer]()

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addAnimations()
        presenter?.viewDidLoad()
    }

    // MARK: - Methods
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: avatarImageView.bounds.height / 2)
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "avatarPlaceholder.jpeg"),
                                    options: [.processor(processor)]) {[weak self] _ in
            self?.removeAnimations()
        }
    }

    func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }

        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
        alertPresenter.showLogoutAlert { [weak self] in
            self?.presenter?.logout()
        }
    }

    private func addAnimations() {
        let avatarImageGradientFrame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        addGradient(on: avatarImageView, with: avatarImageGradientFrame)
        let nameLabelGradientFrame = CGRect(origin: CGPoint(x: 0, y: 7), size: CGSize(width: 223, height: 18))
        addGradient(on: nameLabel, with: nameLabelGradientFrame)
        let loginNameLabelGradientFrame = CGRect(origin: .zero, size: CGSize(width: 89, height: 18))
        addGradient(on: loginNameLabel, with: loginNameLabelGradientFrame)
        let descriptionLabelGradientFrame = CGRect(origin: .zero, size: CGSize(width: 67, height: 18))
        addGradient(on: descriptionLabel, with: descriptionLabelGradientFrame)
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

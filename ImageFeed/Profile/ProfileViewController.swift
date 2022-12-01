//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1234 on 26.10.2022.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let profileService = ProfileService.shared

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails(with: profileService.profile)
        addObserverAvatarURL()
    }
    // MARK: - Methods
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
    }

    private func addObserverAvatarURL() {
        NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateAvatar()
            }
        updateAvatar()
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: avatarImageView.bounds.height / 2)
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "avatarPlaceholder.jpeg"),
                                    options: [.processor(processor)])
    }

    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }

        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

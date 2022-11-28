//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1234 on 26.10.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let profileService = ProfileService.shared

    private var profileImageServiceObserver: NSObjectProtocol?
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileDetails(with: profileService.profile)

    }
    // MARK: - Methods
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
    }

    private func addObserverAvatarURL() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }

    private func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL)
            else { return }
            // TODO [Sprint 11] Обновить аватар, используя Kingfisher
        }
    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }

        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

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

    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }

        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

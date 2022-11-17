//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1234 on 26.10.2022.
//

import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    // MARK: - Methods
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
    }
}

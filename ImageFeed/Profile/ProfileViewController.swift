//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1234 on 26.10.2022.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
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
        updateProfileDetails(with: profileService.profile)
        addObserverAvatarURL()
    }

    // MARK: - Methods
    @IBAction private func didTapLogoutButton(_ sender: UIButton) {
        alertPresenter.showLogoutAlert {
            self.tokenStorage.removeToken()
            self.cleanCookie()
            self.switchToSplashController()
        }
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
                                    options: [.processor(processor)]) {[weak self] _ in
            self?.removeAnimations()
        }
    }

    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }

        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    private func switchToSplashController() {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

            // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
            let splashController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "SplashViewController")

            // Установим в `rootViewController` полученный контроллер
            window.rootViewController = splashController
        }

    private func cleanCookie() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
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

//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Filosuf on 20.01.2023.
//

import UIKit
import WebKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Properties
    var view: ProfileViewControllerProtocol?
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared

    // MARK: - Methods
    func viewDidLoad() {
        view?.updateProfileDetails(with: profileService.profile)
        addObserverAvatarURL()
    }

    func logout() {
        tokenStorage.removeToken()
        cleanCookie()
        switchToSplashController()
    }

    // MARK: - Private methods
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
        view?.updateAvatar(with: url)
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

    private func switchToSplashController() {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            let splashController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "SplashViewController")
            window.rootViewController = splashController
        }
}

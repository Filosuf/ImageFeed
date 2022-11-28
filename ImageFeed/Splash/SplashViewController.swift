//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Filosuf on 14.11.2022.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    // MARK: - Properties
    private let authService: OAuth2ServiceProtocol = OAuth2Service()
    private let profileService = ProfileService.shared
    private let showAuthVCIdentifier = "ShowAuthVC"

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAplication()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //так как viewDidAppear срабатывает при изменении window.rootViewController, необходимо дополнительно скрыть индикатор
        UIBlockingProgressHUD.dismiss()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим, что переходим на авторизацию
        if segue.identifier == showAuthVCIdentifier {

            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthVCIdentifier)") }

            // Установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }

    // MARK: - Methods
    private func startAplication() {
        if let token = OAuth2TokenStorage().token {
            print("token found = \(token)")
            //так как viewDidAppear срабатывает при изменении window.rootViewController, необходимо дополнительно скрыть индикатор
            UIBlockingProgressHUD.show()
            getProfile(with: token)
        } else {
            print("token not found")
            performSegue(withIdentifier: showAuthVCIdentifier, sender: nil)
        }
    }

    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }

        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            UIBlockingProgressHUD.show()
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        authService.fetchAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                self.getProfile(with: accessToken)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Error = \(error.localizedDescription)")
            }
        }
    }

    ///Загрузка данных профиля пользователя
    private func getProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {return}

            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(_):
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
}

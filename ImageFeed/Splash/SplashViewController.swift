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
    
    // MARK: - LifeCycle
    private let showAuthVCIdentifier = "ShowAuthVC"

    // MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAplication()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
            switchToTabBarController()
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
        dismiss(animated: true) { [weak self] in
            ProgressHUD.show()
            guard let self = self else { return }
//            self.fetchOAuthToken(code)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
                self.fetchOAuthToken(code)
            }
        }
    }

    private func fetchOAuthToken(_ code: String) {
        authService.fetchAuthToken(with: code) { [weak self] result in
            ProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                ProgressHUD.dismiss()
//                OAuth2TokenStorage().token = accessToken
                self.switchToTabBarController()
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
            }
        }
    }

}

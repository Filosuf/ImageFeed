//
//  AlertPresenter.swift
//
//  Created by 1234 on 22.08.2022.
//

import Foundation
import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showErrorAlert(message: String, action: @escaping () -> Void) {
        guard let viewController = viewController else { return }

        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: message,
            preferredStyle: .alert)

        alert.view.accessibilityIdentifier = "error_alert"

        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            action()
        }

        alert.addAction(action)
        
        viewController.present(alert, animated: true, completion: nil)
    }

    func showLogoutAlert(action: @escaping () -> Void) {
        guard let viewController = viewController else { return }

        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)

        alert.view.accessibilityIdentifier = "error_alert"

        let action = UIAlertAction(title: "Выйти", style: .destructive) { _ in
            action()
        }

        let cancel = UIAlertAction(title: "Отмена", style: .cancel)

        alert.addAction(action)
        alert.addAction(cancel)

        viewController.present(alert, animated: true, completion: nil)
    }
}

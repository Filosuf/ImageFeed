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

        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: "Что-то пошло не так(", // заголовок всплывающего окна
            message: message, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        alert.view.accessibilityIdentifier = "error_alert"

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "Ок", style: .default) { _ in
            action()
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        viewController.present(alert, animated: true, completion: nil)
    }
}

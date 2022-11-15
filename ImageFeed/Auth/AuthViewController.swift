//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Filosuf on 09.11.2022.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Properties
    private let identifier = "ShowWebView"
    private let authService: OAuth2ServiceProtocol = OAuth2Service()
    weak var delegate: AuthViewControllerDelegate?
    private var bearerToken = ""

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for \(identifier)")
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        authService.fetchAuthToken(with: code) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                OAuth2TokenStorage().token = accessToken
                self.delegate?.authViewController(self, didAuthenticateWithCode: accessToken)
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    self.delegate?.authViewController(self, didAuthenticateWithCode: accessToken)
//                }
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

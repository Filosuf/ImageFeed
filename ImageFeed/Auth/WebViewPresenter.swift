//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Filosuf on 19.01.2023.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol

    // MARK: - LifeCycle
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    // MARK: - Methods
    func viewDidLoad() {
        loadAutorizeScreen()
        didUpdateProgressValue(0)
    }

    private func loadAutorizeScreen() {
        let request = authHelper.authRequest()
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.1
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    } 
}

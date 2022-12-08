//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Filosuf on 26.11.2022.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    // MARK: - Properties
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    private static var isEnable = false

    // MARK: - Methods
    static func show() {
        if isEnable { return }
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
        isEnable = true
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
        isEnable = false
    }

}

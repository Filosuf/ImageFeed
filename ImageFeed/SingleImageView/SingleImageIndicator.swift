//
//  SingleImageIndicator.swift
//  ImageFeed
//
//  Created by Filosuf on 08.12.2022.
//

import UIKit
import Kingfisher

struct SingleImageIndicator: Indicator {
    let view: UIView = UIActivityIndicatorView(style: .large)

    func startAnimatingView() { view.isHidden = false }
    func stopAnimatingView() { view.isHidden = true }

    init() {
        view.backgroundColor = .darkGray
    }
}

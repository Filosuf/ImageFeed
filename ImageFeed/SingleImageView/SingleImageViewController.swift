//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by 1234 on 27.10.2022.
//

import UIKit

final class SingleImageViewController: UIViewController {

    var image: UIImage! {
            didSet {
                guard isViewLoaded else { return } // 1
                imageView.image = image // 2
                rescaleAndCenterImageInScrollView(image: image)
            }
        }

    @IBOutlet var scrollView: UIScrollView!
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
            super.viewDidLoad()
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
        }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

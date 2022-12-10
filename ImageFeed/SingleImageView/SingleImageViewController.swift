//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by 1234 on 27.10.2022.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {

    // MARK: - Properties
    var image: UIImage? {
        didSet {
            guard let image = image, isViewLoaded else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    var fullImageUrl: String? {
        didSet {
            guard isViewLoaded else { return }
            getImage(with: fullImageUrl)
        }
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!

    private let minZoomScale = 0.1
    private let maxZoomScale = 1.25

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        scrollView.minimumZoomScale = 1
//        scrollView.maximumZoomScale = 1.25
        getImage(with: fullImageUrl)
    }

    // MARK: - Methods
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    private func getImage(with url: String?) {
        guard let urlImage = url, let url = URL(string: urlImage) else { return }

        UIBlockingProgressHUD.show()

        imageView.kf.setImage(with: url, placeholder: UIImage(named: "imagePlaceholder"), options: []) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.image = data.image
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                return
            }
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        let visibleRectSize = view.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
//        scrollView.bounds.size = visibleRectSize
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        imageView.frame = frameToCenter
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
            self.centerImage()
        }
}

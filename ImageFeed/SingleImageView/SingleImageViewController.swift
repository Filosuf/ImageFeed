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
    var image: UIImage?
    var fullImageUrl: String? 

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!

    private let minZoomScale = 0.03
    private let maxZoomScale = 1.25

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(with: fullImageUrl)
        rescaleAndCenterImageInScrollView(image: UIImage(named: "imagePlaceholder")!)
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
                    self.rescaleAndCenterImageInScrollView(image: data.image)
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

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func centerImage() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}

//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Filosuf on 20.01.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
}

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var photosCount: Int = 0

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func fetchPhotosNextPage(row: Int) {

    }

    func handleAnswerLike(index: Int) {

    }

    func fetchPhoto(index: Int) -> Photo {
        return Photo(photoResult: PhotoResult(id: "", width: 10, height: 10, createdAt: Date(), isLiked: true, description: "", urls: UrlsResult(raw: "", full: "", regular: "", small: "", thumb: "")))
    }


}

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    // MARK: - Properties
    var presenter: ImagesListViewPresenterProtocol?
    var loadCalled = false

    //MARK: - Methods
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {

    }

    func updateCell(photo: Photo, index: Int) {

    }

    func showErrorAlert() {

    }

    func dismissUIBlocking() {

    }
}

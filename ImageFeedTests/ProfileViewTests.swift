//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Filosuf on 20.01.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    // MARK: - Properties
    var viewDidLoadCalled = false
    var view: ProfileViewControllerProtocol?

    //MARK: - Methods
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func logout() { }
}

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    // MARK: - Properties
    var presenter: ProfileViewPresenterProtocol?

    var loadCalled = false

    //MARK: - Methods
    func updateProfileDetails(with profile: Profile?) { }
    func updateAvatar(with url: URL) { }
}

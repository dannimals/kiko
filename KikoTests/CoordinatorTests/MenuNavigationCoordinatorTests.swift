import XCTest
import Foundation
import KikoModels
@testable import Kiko

class MenuNavigationCoordinatorTests: XCTestCase {

    let rootViewController = UINavigationController(nibName: nil, bundle: nil)
    let mockMoodManager = MockMoodManager()
    let menuNavigationCoordinator = MenuNavigationCoordinator()

    override func setUp() {
        super.setUp()

        menuNavigationCoordinator.configure(rootViewController: rootViewController, moodManager: mockMoodManager)
    }

    func testProperties() {
        XCTAssertNotNil(menuNavigationCoordinator.rootViewController)
        XCTAssertNotNil(menuNavigationCoordinator.moodManager)
    }

    func testShowWavesViewController() {
        XCTAssertEqual(menuNavigationCoordinator.rootViewController.childViewControllers.count, 0)
        menuNavigationCoordinator.showWavesViewController()
        XCTAssertEqual(menuNavigationCoordinator.rootViewController.childViewControllers.count, 1)
    }

    func testStart() {
        XCTAssertEqual(menuNavigationCoordinator.rootViewController.childViewControllers.count, 0)
        menuNavigationCoordinator.showWavesViewController()
        XCTAssertEqual(menuNavigationCoordinator.rootViewController.childViewControllers.count, 1)
    }
}

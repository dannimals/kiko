import XCTest
import Foundation
import KikoModels
@testable import Kiko

class MoodNavigationCoordinatorTests: XCTestCase {

    let rootViewController = UINavigationController(nibName: nil, bundle: nil)
    let mockMoodManager = MockMoodManager()
    let moodNavigationCoordinator = MoodNavigationCoordinator()

    override func setUp() {
        super.setUp()

        moodNavigationCoordinator.configure(rootViewController: rootViewController, moodManager: mockMoodManager)
    }

    func testProperties() {
        XCTAssertNotNil(moodNavigationCoordinator.rootViewController)
        XCTAssertNotNil(moodNavigationCoordinator.moodManager)
    }

    func testShowWavesViewController() {
        XCTAssertEqual(moodNavigationCoordinator.rootViewController.childViewControllers.count, 0)
        moodNavigationCoordinator.showWavesViewController()
        XCTAssertEqual(moodNavigationCoordinator.rootViewController.childViewControllers.count, 1)
    }

    func testStart() {
        XCTAssertEqual(moodNavigationCoordinator.rootViewController.childViewControllers.count, 0)
        moodNavigationCoordinator.showWavesViewController()
        XCTAssertEqual(moodNavigationCoordinator.rootViewController.childViewControllers.count, 1)
    }
}

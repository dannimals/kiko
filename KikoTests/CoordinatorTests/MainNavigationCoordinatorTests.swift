import XCTest
import Foundation
import KikoModels
@testable import Kiko

class MainNavigationCoordinatorTests: XCTestCase {

    let mockCalendarManager = MockCalendarManager()
    let mockMoodManager = MockMoodManager()
    let mockMenuCoordinator = MockMenuNavigationCoodinator()
    let window = UIWindow()

    lazy var mainCoordinator: MainNavigationCoordinator = {
        return MainNavigationCoordinator(window: window, calendarManager: mockCalendarManager, moodManager: mockMoodManager)
    }()

    func testProperties() {
        XCTAssertEqual(window, mainCoordinator.window)
        XCTAssertNotNil(mainCoordinator.moodManager)
        XCTAssertNotNil(mainCoordinator.menuNavigationCoordinator)
        XCTAssertEqual(mockCalendarManager.currentWeekDates, mainCoordinator.calendarManager.currentWeekDates)
        XCTAssertNotNil(mainCoordinator.mainViewController)
    }

    func testStart() {
        XCTAssertNotNil(mainCoordinator.window)
        XCTAssertNil(window.rootViewController)
        mainCoordinator.start()
        XCTAssertEqual(window.rootViewController, mainCoordinator.mainViewController)
        XCTAssertTrue(window.isKeyWindow)
    }

}

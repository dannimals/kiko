import XCTest
import Foundation
import KikoModels
@testable import Kiko

class DateManagerTests: XCTestCase {
    lazy var augustDateManager: DateManageable = {
        return DateManager(month: Month.august, year: 2018)
    }()
    lazy var febDateManager: DateManageable = {
        return DateManager(month: Month.february, year: 2018)
    }()

    func testNumberOfDays() {
        XCTAssertEqual(augustDateManager.numberOfDays, 31)
        XCTAssertEqual(febDateManager.numberOfDays, 28)
    }

    func testMonth() {
        XCTAssertEqual(augustDateManager.month, Month.august)
        XCTAssertEqual(febDateManager.month, Month.february)
    }

    func testNumberOfDay() {
        XCTAssertEqual(augustDateManager.numberOf(day: .monday), 4)
        XCTAssertEqual(augustDateManager.numberOf(day: .tuesday), 4)
        XCTAssertEqual(augustDateManager.numberOf(day: .wednesday), 5)
        XCTAssertEqual(augustDateManager.numberOf(day: .thursday), 5)
        XCTAssertEqual(augustDateManager.numberOf(day: .friday), 5)
        XCTAssertEqual(augustDateManager.numberOf(day: .saturday), 4)
        XCTAssertEqual(augustDateManager.numberOf(day: .sunday), 4)

        XCTAssertEqual(febDateManager.numberOf(day: .monday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .tuesday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .wednesday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .thursday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .friday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .saturday), 4)
        XCTAssertEqual(febDateManager.numberOf(day: .sunday), 4)
    }
}

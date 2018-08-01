import XCTest
import Foundation
import KikoModels
@testable import Kiko

class DateManagerTests: XCTestCase {
    var dateManager: DateManageable?

    override func setUp() {
        super.setUp()

        dateManager = DateManager(month: Month.february, year: 2018)
    }

    override func tearDown() {
        super.tearDown()

        dateManager = nil
    }

    func testNumberOfDays() {
        XCTAssertEqual(dateManager!.numberOfDays, 28)
    }

    func testMonth() {
        XCTAssertEqual(dateManager!.month, Month.february)
    }

    func testNumberOfDay() {
        XCTAssertEqual(dateManager!.numberOf(day: .monday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .tuesday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .wednesday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .thursday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .friday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .saturday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .sunday), 4)
    }
}

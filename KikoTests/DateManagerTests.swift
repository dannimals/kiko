import XCTest
import Foundation
import KikoModels
@testable import Kiko

class DateManagerTests: XCTestCase {
    var dateManager: DateManageable?
    lazy var date: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: "22-02-2017")!
    }()

    override func setUp() {
        super.setUp()

        dateManager = DateManager(date: date)
    }

    override func tearDown() {
        super.tearDown()

        dateManager = nil
    }

    func testNumberOfDays() {
        XCTAssertEqual(dateManager!.numberOfDays, 28)
    }

    func testNumberOfDay() {
        XCTAssertEqual(dateManager!.numberOf(day: .Monday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Tuesday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Wednesday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Thursday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Friday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Saturday), 4)
        XCTAssertEqual(dateManager!.numberOf(day: .Sunday), 4)
    }
}

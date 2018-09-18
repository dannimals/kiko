import XCTest
import Foundation
import KikoModels
@testable import Kiko

class CalendarManagerTests: XCTestCase {
    var calendarManager: CalendarManager?
    lazy var date: Date = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: "02-08-2018") ?? Date()
        return date
    }()

    override func setUp() {
        super.setUp()

        calendarManager = CalendarManager(date: date)
    }

    override func tearDown() {
        super.tearDown()

        calendarManager = nil
    }

    func testSetupDates() {
        var lastWeekDates: [Date] = []
        var currentWeekDates: [Date] = []
        var nextWeekDates: [Date] = []
        let startOfLastWeek = date.lastStartOfWeek
        let startOfCurrentWeek = date.startOfWeek
        let startOfNextweek = date.nextStartOfWeek

        for i in 0..<7 {
            let dayForLastWeek = startOfLastWeek.dateFromAddingDays(i)
            let dayForCurrentWeek = startOfCurrentWeek.dateFromAddingDays(i)
            let dayForNextWeek = startOfNextweek.dateFromAddingDays(i)
            lastWeekDates.append(dayForLastWeek)
            currentWeekDates.append(dayForCurrentWeek)
            nextWeekDates.append(dayForNextWeek)
        }

        XCTAssertEqual(calendarManager!.lastWeekDates, lastWeekDates)
        XCTAssertEqual(calendarManager!.currentWeekDates, currentWeekDates)
        XCTAssertEqual(nextWeekDates, calendarManager!.nextWeekDates)
        XCTAssertEqual(currentWeekDates.first!, calendarManager!.currentWeekDates.first!)
        XCTAssertEqual(calendarManager!.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.nextWeekDates.count, 7)
    }

    func testComputedDates() {
        XCTAssertEqual(Month.july, calendarManager!.displayedMonth)
    }

    func testLoadNextWeek() {
        guard let calendarManager = calendarManager else { XCTFail(); return }
        calendarManager.loadNextWeek()
        XCTAssertEqual(calendarManager.displayedMonth, Month.august)

        let newLastStartOfWeek = calendarManager.lastWeekDates.first
        XCTAssertEqual(newLastStartOfWeek?.day, 29)
        XCTAssertEqual(newLastStartOfWeek?.month, Month.july)

        let newCurrentStartOfWeek = calendarManager.currentWeekDates.first
        XCTAssertEqual(newCurrentStartOfWeek?.day, 5)
        XCTAssertEqual(newCurrentStartOfWeek?.month, Month.august)

        let newNextStartOfWeek = calendarManager.nextWeekDates.first
        XCTAssertEqual(newNextStartOfWeek?.day, 12)
        XCTAssertEqual(newNextStartOfWeek?.month, Month.august)

        XCTAssertEqual(calendarManager.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager.nextWeekDates.count, 7)
    }

    func testLoadLastWeek() {
        guard let calendarManager = calendarManager else { XCTFail(); return }

        calendarManager.loadLastWeek()
        XCTAssertEqual(calendarManager.displayedMonth, Month.july)

        let newLastStartOfWeek = calendarManager.lastWeekDates.first
        XCTAssertEqual(newLastStartOfWeek?.day, 15)
        XCTAssertEqual(newLastStartOfWeek?.month, Month.july)

        let newCurrentStartOfWeek = calendarManager.currentWeekDates.first
        XCTAssertEqual(newCurrentStartOfWeek?.day, 22)
        XCTAssertEqual(newCurrentStartOfWeek?.month, Month.july)

        let newNextStartOfWeek = calendarManager.nextWeekDates.first
        XCTAssertEqual(newNextStartOfWeek?.day, 29)
        XCTAssertEqual(newNextStartOfWeek?.month, Month.july)

        XCTAssertEqual(calendarManager.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager.nextWeekDates.count, 7)
    }
}

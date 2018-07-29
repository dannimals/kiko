import XCTest
import Foundation
import KikoModels
@testable import Kiko

class CalendarManagerTests: XCTestCase {
    var calendarManager: CalendarManager?
    lazy var date: Date = {
        let dateString = dateFormatter.string(from: Date())
        let date = dateFormatter.date(from: dateString)
        return date!
    }()
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter
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
        XCTAssertEqual(calendarManager?.earliestDate, lastWeekDates.first!)
        XCTAssertEqual(currentWeekDates.first!, calendarManager!.currentWeekDates.first!)
        XCTAssertEqual(calendarManager!.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.nextWeekDates.count, 7)
        XCTAssertFalse(calendarManager!.hasNewDates)
    }

    func testComputedDates() {
        XCTAssertEqual(calendarManager!.displayedStartOfWeekDate.month, calendarManager!.displayedMonth)
    }

    func testSetupDatesIndexes() {
        let datesIndexesDict = calendarManager!.datesIndexesDict
        XCTAssertEqual(datesIndexesDict[calendarManager!.earliestDate], -7)
        XCTAssertEqual(datesIndexesDict[calendarManager!.lastWeekDates.first!], -7)
        XCTAssertEqual(datesIndexesDict[calendarManager!.currentWeekDates.first!], 0)
        XCTAssertEqual(datesIndexesDict[calendarManager!.nextWeekDates.last!], 13)
        XCTAssertEqual(datesIndexesDict.count, 21)
    }

    func testLoadNextWeek() {
        let currentEarliestDate = calendarManager!.earliestDate
        let originalDatesIndexesCount = calendarManager!.datesIndexesDict.count
        let originalDateIndex = calendarManager!.datesIndexesDict[date]!

        XCTAssertEqual(calendarManager!.currentWeekDates.first!, calendarManager!.displayedStartOfWeekDate)
        XCTAssertEqual(calendarManager!.lastWeekDates.first!, currentEarliestDate)
        calendarManager!.loadNextWeek()
        XCTAssertEqual(calendarManager!.currentWeekDates.first!, calendarManager!.displayedStartOfWeekDate)
        XCTAssertEqual(calendarManager!.lastWeekDates.last!.lastStartOfWeek, currentEarliestDate)
        XCTAssertEqual(calendarManager!.datesIndexesDict.count, originalDatesIndexesCount + 7)
        XCTAssertEqual(calendarManager!.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.nextWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.datesIndexesDict[date], originalDateIndex)
        XCTAssertTrue(calendarManager!.hasNewDates)
    }

    func testLoadLastWeek() {
        let currentEarliestDate = calendarManager!.earliestDate
        let originalDatesIndexesCount = calendarManager!.datesIndexesDict.count
        let originalDateIndex = calendarManager!.datesIndexesDict[date]!

        XCTAssertEqual(calendarManager!.currentWeekDates.first!, calendarManager!.displayedStartOfWeekDate)
        XCTAssertEqual(calendarManager!.lastWeekDates.first!, currentEarliestDate)
        calendarManager!.loadLastWeek()
        XCTAssertEqual(calendarManager!.currentWeekDates.first!, calendarManager!.displayedStartOfWeekDate)
        XCTAssertEqual(calendarManager!.lastWeekDates.last!.startOfWeek, calendarManager!.earliestDate)
        XCTAssertEqual(calendarManager!.datesIndexesDict.count, originalDatesIndexesCount + 7)
        XCTAssertEqual(calendarManager!.datesIndexesDict[date], originalDateIndex)
        XCTAssertEqual(calendarManager!.lastWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.currentWeekDates.count, 7)
        XCTAssertEqual(calendarManager!.nextWeekDates.count, 7)
        XCTAssertTrue(calendarManager!.hasNewDates)
    }
}

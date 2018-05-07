
import XCTest
import Foundation
import KikoModels
@testable import Kiko

class MoodLogViewModelTests: XCTestCase {
    var moodLogViewModel: MoodLogViewModel?
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

        moodLogViewModel = MoodLogViewModel(date: date)
    }
    
    override func tearDown() {
        super.tearDown()

        moodLogViewModel = nil
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

        XCTAssertEqual(moodLogViewModel!.lastWeekDates, lastWeekDates)
        XCTAssertEqual(moodLogViewModel!.currentWeekDates, currentWeekDates)
        XCTAssertEqual(moodLogViewModel!.nextWeekDates, nextWeekDates)
        XCTAssertEqual(moodLogViewModel?.earliestDate, lastWeekDates.first!)
        XCTAssertEqual(moodLogViewModel!.displayedStartOfWeekDate, currentWeekDates.first!)
        XCTAssertFalse(moodLogViewModel!.hasNewDates)
    }

    func testComputedDates() {
        XCTAssertEqual(moodLogViewModel!.displayedStartOfWeekDate.month, moodLogViewModel!.displayedMonth)
    }

    func testSetupDatesIndexes() {
        let datesIndexesDict = moodLogViewModel!.datesIndexesDict
        XCTAssertEqual(datesIndexesDict[moodLogViewModel!.earliestDate], -7)
        XCTAssertEqual(datesIndexesDict[moodLogViewModel!.lastWeekDates.first!], -7)
        XCTAssertEqual(datesIndexesDict[moodLogViewModel!.currentWeekDates.first!], 0)
        XCTAssertEqual(datesIndexesDict[moodLogViewModel!.nextWeekDates.last!], 13)
        XCTAssertEqual(datesIndexesDict.count, 21)
    }

    func testLoadNextWeek() {
        let currentEarliestDate = moodLogViewModel!.earliestDate
        let originalDatesIndexesCount = moodLogViewModel!.datesIndexesDict.count
        let originalDateIndex = moodLogViewModel!.datesIndexesDict[date]!

        XCTAssertEqual(moodLogViewModel!.currentWeekDates.first!, moodLogViewModel!.displayedStartOfWeekDate)
        XCTAssertEqual(moodLogViewModel!.lastWeekDates.first!, currentEarliestDate)
        moodLogViewModel!.loadNextWeek()
        XCTAssertEqual(moodLogViewModel!.currentWeekDates.first!.nextStartOfWeek, moodLogViewModel!.displayedStartOfWeekDate)
        XCTAssertEqual(moodLogViewModel!.lastWeekDates.first!, currentEarliestDate)
        XCTAssertEqual(moodLogViewModel!.datesIndexesDict.count, originalDatesIndexesCount + 7)
        XCTAssertEqual(moodLogViewModel!.datesIndexesDict[date], originalDateIndex)
        XCTAssertTrue(moodLogViewModel!.hasNewDates)
    }

//    func testLoadLastWeek() {
//        let currentEarliestDate = moodLogViewModel!.earliestDate
//        let originalDatesIndexesCount = moodLogViewModel!.datesIndexesDict.count
//        let originalDateIndex = moodLogViewModel!.datesIndexesDict[date]!
//
//        XCTAssertEqual(moodLogViewModel!.currentWeekDates.first!, moodLogViewModel!.displayedStartOfWeekDate)
//        XCTAssertEqual(moodLogViewModel!.lastWeekDates.first!, currentEarliestDate)
//        moodLogViewModel!.loadNextWeek()
//        XCTAssertEqual(moodLogViewModel!.currentWeekDates.first!.nextStartOfWeek, moodLogViewModel!.displayedStartOfWeekDate)
//        XCTAssertEqual(moodLogViewModel!.lastWeekDates.first!, currentEarliestDate)
//        XCTAssertEqual(moodLogViewModel!.datesIndexesDict.count, originalDatesIndexesCount + 7)
//        XCTAssertEqual(moodLogViewModel!.datesIndexesDict[date], originalDateIndex)
//        XCTAssertTrue(moodLogViewModel!.hasNewDates)
//    }
//}

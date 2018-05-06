
import XCTest
import Foundation
import KikoModels
@testable import Kiko

class MoodLogViewModelTests: XCTestCase {
    var moodLogViewModel: MoodLogViewModel?
    let date = Date()

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
    }

    func testSetupDatesIndexes() {
        
    }

}

import KikoModels
import KikoUIKit
@testable import Kiko

class MockCalendarManager: CalendarManaging {
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    func date(from dateString: String) -> Date {
        return dateFormatter.date(from: dateString)!
    }

    lazy var currentWeekDates: [Date] = {
        return [
            date(from: "2018-08-19"),
            date(from: "2018-08-20"),
            date(from: "2018-08-21"),
            date(from: "2018-08-22"),
            date(from: "2018-08-23"),
            date(from: "2018-08-24"),
            date(from: "2018-08-25")
        ]
    }()

    lazy var datesIndexesDict: [Date : Int] = {
        var dict = [Date: Int]()
        dict[date(from: "2018-08-12")] = 0
        dict[date(from: "2018-08-13")] = 1
        dict[date(from: "2018-08-14")] = 2
        dict[date(from: "2018-08-15")] = 3
        dict[date(from: "2018-08-16")] = 4
        dict[date(from: "2018-08-17")] = 5
        dict[date(from: "2018-08-18")] = 6
        return dict
    }()
    var displayedMonth: Month = .august

    var displayedStartOfWeekDate: Date = Date()

    lazy var earliestDate: Date = { return date(from: "2018-08-12") }()

    var hasNewDates: Bool = false

    lazy var lastWeekDates: [Date] = {
        return [
            date(from: "2018-08-12"),
            date(from: "2018-08-13"),
            date(from: "2018-08-14"),
            date(from: "2018-08-15"),
            date(from: "2018-08-16"),
            date(from: "2018-08-17"),
            date(from: "2018-08-18")
        ]
    }()
    lazy var nextWeekDates: [Date] = {
        return [
            date(from: "2018-08-26"),
            date(from: "2018-08-27"),
            date(from: "2018-08-28"),
            date(from: "2018-08-29"),
            date(from: "2018-08-30"),
            date(from: "2018-08-31"),
            date(from: "2018-09-01")
        ]
    }()
    lazy var today: Date = { return date(from: "2018-08-22") }()


    func dateForIndexPath(_ indexPath: IndexPath) -> Date {
        return lastWeekDates.first!
    }

    var isLastWeekLoaded = false
    func loadLastWeek() {
        isLastWeekLoaded = true
    }
    var isNextWeekLoaded = false
    func loadNextWeek() {
        isNextWeekLoaded = true
    }

}

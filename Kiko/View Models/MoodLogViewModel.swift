
import KikoModels

class MoodLogViewModel {

//    private(set) var lastStartOfWeekDay: Int
//    private(set) var nextStartOfWeekDay: Int
    private(set) var displayedStartOfWeekDay: Int
    var currentDay: Int {
        return calendarManager.currentDay
    }
    private(set) var displayedMonth: Month

    private let calendarManager: CalendarManager

    init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager
        self.displayedMonth = calendarManager.currentMonth
        self.displayedStartOfWeekDay = calendarManager.startOfWeekDay
//        self.lastStartOfWeekDay = calendarManager.
    }
}

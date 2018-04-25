
import KikoModels

class MoodLogViewModel {
    
    private(set) var lastWeekDates: [Date] = []
    private(set) var currentWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []

    var displayedStartOfWeekDate: Date = unwrapOrElse(Date().startOfWeek, fallback: Date())

    var displayDates: [Date] {
        return lastWeekDates + currentWeekDates + nextWeekDates
    }

    var currentDay: Int {
        return calendarManager.currentDay
    }
    private(set) var displayedMonth: Month

    private let calendarManager: CalendarManager

    init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager
        self.displayedMonth = calendarManager.currentMonth
        updateWeeksForDate(Date())
    }

    func index(of date: Date) -> Int{
        let indexOfDate = unwrapOrElse(displayDates.index(of: date), fallback: 0)
        return indexOfDate
    }

    func updateWeeksForDate(_ date: Date) {
        lastWeekDates = lastWeekDatesFrom(date)
        currentWeekDates = currentWeekDatesFrom(date)
        nextWeekDates = nextWeekDatesFrom(date)
    }

    func dayForIndexPath(_ indexPath: IndexPath) -> Int {
        return displayDates[indexPath.row].day
    }

    func currentWeekDatesFrom(_ date: Date) -> [Date] {
        var dates: [Date] = []
        let startOfWeek = unwrapOrElse(date.startOfWeek, fallback: Date())
        for i in 0..<7 {
            let day = startOfWeek.dateFromAddingDays(i)
            dates.append(day)
        }
        return dates
    }

    private func lastWeekDatesFrom(_ date: Date) -> [Date] {
        var dates: [Date] = []
        let startOfWeek = unwrapOrElse(date.lastStartOfWeek, fallback: Date())
        for i in 0..<7 {
            let day = startOfWeek.dateFromAddingDays(i)
            dates.append(day)
        }
        return dates
    }

    private func nextWeekDatesFrom(_ date: Date) -> [Date] {
        var dates: [Date] = []
        let startOfWeek = unwrapOrElse(date.nextStartOfWeek, fallback: Date())
        for i in 0..<7 {
            let day = startOfWeek.dateFromAddingDays(i)
            dates.append(day)
        }
        return dates
    }

}

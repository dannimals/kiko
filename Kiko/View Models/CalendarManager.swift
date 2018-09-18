import KikoModels

public protocol CalendarManaging {
    var displayedMonth: Month { get }
    var currentWeekDates: [Date] { get }
    var lastWeekDates: [Date] { get }
    var nextWeekDates: [Date] { get }
    var today: Date { get }

    func dateForIndexPath(_ indexPath: IndexPath) -> Date
    func loadLastWeek()
    func loadNextWeek()
}

class CalendarManager: CalendarManaging {

    private(set) var currentWeekDates: [Date] = []
    private(set) var lastWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []

    var displayedMonth: Month { return min(currentWeekDates.first!.month, currentWeekDates.last!.month)
    }
    var today: Date {
        return Date()
    }

    required init(date: Date) {
        setup(with: date)
    }

    func dateForIndexPath(_ indexPath: IndexPath) -> Date {
        let allDates = lastWeekDates + currentWeekDates + nextWeekDates
        return allDates[indexPath.row]
    }

    func loadNextWeek() {
        let firstDayOfNextWeek = currentWeekDates.first!.nextStartOfWeek
        updateDatesFor(firstDayOfNextWeek)
    }

    func loadLastWeek() {
        let firstDayOfLastWeek = currentWeekDates.first!.lastStartOfWeek
        updateDatesFor(firstDayOfLastWeek)
    }

    private func setup(with date: Date) {
        updateDatesFor(date)
    }

    private func updateDatesFor(_ date: Date) {
        lastWeekDates = []
        currentWeekDates = []
        nextWeekDates = []

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
    }
}

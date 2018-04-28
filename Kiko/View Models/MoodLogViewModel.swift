
import KikoModels

class MoodLogViewModel {

    private(set) var lastWeekDates: [Date] = []
    private(set) var currentWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []
    private(set) var datesIndexesDict: [Date: Int] = [:]
    static let offset = 7

    var displayedStartOfWeekDate: Date = unwrapOrElse(Date().startOfWeek, fallback: Date())
    var currentDay: Int { return calendarManager.currentDay }
    var displayedMonth: Month { return displayedStartOfWeekDate.month }

    private let calendarManager: CalendarManager

    init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager
        updateWeeksForDate(Date())
        update(dates: lastWeekDates, offset: -7)
        update(dates: currentWeekDates, offset: 0)
        update(dates: nextWeekDates, offset: 7)
    }

    func index(for date: Date) -> Int {
        guard let index = datesIndexesDict[date] else { return 0 }
        return index + MoodLogViewModel.offset
    }

    func day(for indexPath: IndexPath) -> Int {
        let indexPathWithOffset = IndexPath(row: indexPath.row - 7, section: 0)
        guard let dateIndex = datesIndexesDict.first(where: { $0.value == indexPathWithOffset.row }) else { return 0 }
        return dateIndex.key.day
    }

    func updateWeeksForDate(_ date: Date) {
        lastWeekDates = lastWeekDatesFrom(date)
        currentWeekDates = currentWeekDatesFrom(date)
        nextWeekDates = nextWeekDatesFrom(date)
    }

    func scrollToNextWeek() {
        displayedStartOfWeekDate = displayedStartOfWeekDate.nextStartOfWeek
        let dateOffset = datesIndexesDict[nextWeekDates.last!] ?? 0
        updateWeeksForDate(displayedStartOfWeekDate)
        update(dates: nextWeekDates, offset: dateOffset + 1)
    }

    func indexes(of dates: [Date]) -> [Int] {
        var indexes: [Int] = []
        for date in dates {
            guard let index = datesIndexesDict[date] else { continue }
            indexes.append(index + MoodLogViewModel.offset)
        }
        return indexes
    }

    func update(dates: [Date], offset: Int) {
        for (i, date) in dates.enumerated() {
            datesIndexesDict[date] = i + offset
        }
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

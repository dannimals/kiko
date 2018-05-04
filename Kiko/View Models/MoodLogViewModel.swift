
import KikoModels

class MoodLogViewModel {

    private(set) var lastWeekDates: [Date] = []
    private(set) var currentWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []
    private(set) var datesIndexesDict: [Date: Int] = [:]
    private(set) var earliestDate = Date()
    static let offset = 7

    private(set) var displayedStartOfWeekDate: Date = unwrapOrElse(Date().startOfWeek, fallback: Date())
    var displayedMonth: Month { return displayedStartOfWeekDate.month }
    var hasNewDates = false

    init() {
        updateWeeksForDate(Date())
        updateDatesIndexes(dates: lastWeekDates, offset: -7)
        updateDatesIndexes(dates: currentWeekDates, offset: 0)
        updateDatesIndexes(dates: nextWeekDates, offset: 7)
    }

    func index(for date: Date) -> Int? {
        guard let index = datesIndexesDict[date], let firstIndex = datesIndexesDict[earliestDate] else { return nil }
        return index - firstIndex
    }

    func day(for indexPath: IndexPath) -> Int {
        let dateForIndexPath = earliestDate.dateFromAddingDays(indexPath.row)
        return dateForIndexPath.day
    }

    private func updateWeeksForDate(_ date: Date) {
        lastWeekDates = lastWeekDatesFrom(date)
        currentWeekDates = currentWeekDatesFrom(date)
        nextWeekDates = nextWeekDatesFrom(date)
        if let lastWeekDate = lastWeekDates.first, lastWeekDate < earliestDate {
            earliestDate = lastWeekDate
        }
    }

    func loadNextWeek() {
        setDisplayStartOfWeekDate(displayedStartOfWeekDate.nextStartOfWeek)
        let dateOffset = datesIndexesDict[nextWeekDates.last!] ?? 0 + 1
        updateWeeksForDate(displayedStartOfWeekDate)
        updateDatesIndexes(dates: nextWeekDates, offset: dateOffset)
    }

    func loadLastWeek() {
        setDisplayStartOfWeekDate(displayedStartOfWeekDate.lastStartOfWeek)
        let dateOffset = datesIndexesDict[lastWeekDates.first!] ?? 0
        updateWeeksForDate(displayedStartOfWeekDate)
        updateDatesIndexes(dates: lastWeekDates, offset: dateOffset)
    }

    private func setDisplayStartOfWeekDate(_ date: Date) {
        displayedStartOfWeekDate = date
    }

    private func updateDatesIndexes(dates: [Date], offset: Int) {
        hasNewDates = false

        var i = -7
        let initialDates = lastWeekDates + currentWeekDates + nextWeekDates
        if datesIndexesDict.count == 0 {
            for date in initialDates {
                datesIndexesDict[date] = i
                i += 1
            }
        }
        for date in dates {
            guard datesIndexesDict[date] == nil else { return }
            let indexOfEarliestDate = datesIndexesDict[earliestDate] ?? 0
            //TODO there's a bug
            let offset = earliestDate.daysSince(date)
            datesIndexesDict[date] = indexOfEarliestDate + offset
            hasNewDates = true
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

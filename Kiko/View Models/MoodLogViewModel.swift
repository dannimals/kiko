
import KikoModels

class MoodLogViewModel {

    private(set) var lastWeekDates: [Date] = []
    private(set) var currentWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []
    private(set) var datesIndexesDict: [Date: Int] = [:]
    private(set) var earliestDate = Date()

    private(set) var displayedStartOfWeekDate = Date()
    var displayedMonth: Month { return displayedStartOfWeekDate.month }
    var hasNewDates = false

    required init(date: Date) {
        setup(with: date)
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
        updateWeeksForDate(displayedStartOfWeekDate)
        updateDatesIndexes(dates: nextWeekDates)
    }

    func loadLastWeek() {
        setDisplayStartOfWeekDate(displayedStartOfWeekDate.lastStartOfWeek)
        updateWeeksForDate(displayedStartOfWeekDate)
        updateDatesIndexes(dates: lastWeekDates)
    }

    private func setDisplayStartOfWeekDate(_ date: Date) {
        displayedStartOfWeekDate = date
    }

    private func setup(with date: Date) {
        setupDatesFor(date)
        setupDatesIndexes()
        earliestDate = unwrapOrElse(lastWeekDates.first, fallback: Date())
        displayedStartOfWeekDate = unwrapOrElse(currentWeekDates.first, fallback: Date())
    }

    private func setupDatesIndexes() {
        var i = -7
        let initialDates = lastWeekDates + currentWeekDates + nextWeekDates
        if datesIndexesDict.count == 0 {
            for date in initialDates {
                datesIndexesDict[date] = i
                i += 1
            }
        }
    }

    private func setupDatesFor(_ date: Date) {
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

    private func updateDatesIndexes(dates: [Date]) {
        hasNewDates = false

        for date in dates {
            guard datesIndexesDict[date] == nil else { return }
            let indexOfEarliestDate = datesIndexesDict[earliestDate] ?? 0
            //TODO there's a bug
            let offset = date.numberOfDaysSince(earliestDate)
            datesIndexesDict[date] = indexOfEarliestDate - offset
            hasNewDates = true
        }
    }

    private func currentWeekDatesFrom(_ date: Date) -> [Date] {
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

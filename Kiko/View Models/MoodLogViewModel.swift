
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

    func dateForIndexPath(_ indexPath: IndexPath) -> Date {
        return earliestDate.dateFromAddingDays(indexPath.row)
    }

    private func updateEarliestDate() {
        guard let offset = datesIndexesDict[earliestDate] else { return }
        if let lastWeekDate = lastWeekDates.first, lastWeekDate < earliestDate {
            earliestDate = lastWeekDate
            datesIndexesDict[lastWeekDate] = offset - 7
        }
    }

    func loadNextWeek() {
        let newDisplayDate = displayedStartOfWeekDate.nextStartOfWeek
        displayedStartOfWeekDate = newDisplayDate
        updateDatesFor(newDisplayDate)
        updateEarliestDate()
        updateDatesIndexes(dates: nextWeekDates)
    }

    func loadLastWeek() {
        let newDisplayDate = displayedStartOfWeekDate.lastStartOfWeek
        displayedStartOfWeekDate = newDisplayDate
        updateDatesFor(newDisplayDate)
        updateEarliestDate()
        updateDatesIndexes(dates: lastWeekDates)
    }

    private func setup(with date: Date) {
        updateDatesFor(date)
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

    private func updateDatesIndexes(dates: [Date]) {
        hasNewDates = false

        for date in dates {
            guard datesIndexesDict[date] == nil else { continue }
            let indexOfEarliestDate = datesIndexesDict[earliestDate] ?? 0
            let offset = date.numberOfDaysSince(earliestDate)
            datesIndexesDict[date] = indexOfEarliestDate - offset
            hasNewDates = true
        }
    }
}

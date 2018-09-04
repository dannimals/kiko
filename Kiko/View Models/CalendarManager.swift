import KikoModels

public protocol CalendarManaging {
    var currentWeekDates: [Date] { get }
    var datesIndexesDict: [Date: Int] { get }
    var displayedMonth: Month { get }
    var displayedStartOfWeekDate: Date { get }
    var earliestDate: Date { get }
    var hasNewDates: Bool { get set }
    var lastWeekDates: [Date] { get }
    var nextWeekDates: [Date] { get }
    var today: Date { get }

    func dateForIndexPath(_ indexPath: IndexPath) -> Date
    func index(for date: Date) -> Int?
    func loadLastWeek()
    func loadNextWeek()
}

class CalendarManager: CalendarManaging {

    private(set) var currentWeekDates: [Date] = []
    private(set) var datesIndexesDict: [Date: Int] = [:]
    private(set) var displayedStartOfWeekDate = Date()
    private(set) var earliestDate = Date()
    private(set) var lastWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []
    var displayedMonth: Month { return min(displayedStartOfWeekDate.month, displayedStartOfWeekDate.dateFromAddingDays(6).month)
    }
    var hasNewDates = false
    var today: Date {
        return Date()
    }

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

    private func updateEarliestDate() {
        guard let offset = datesIndexesDict[earliestDate] else { return }
        if let lastWeekDate = lastWeekDates.first, lastWeekDate < earliestDate {
            earliestDate = lastWeekDate
            datesIndexesDict[lastWeekDate] = offset - 7
        }
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

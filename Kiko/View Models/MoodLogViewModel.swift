
import KikoModels

class MoodLogViewModel {

    private(set) var lastWeekDates: [Date] = []
    private(set) var currentWeekDates: [Date] = []
    private(set) var nextWeekDates: [Date] = []
    private(set) var datesIndexesDict: [Date: Int] = [:]
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
        guard let index = datesIndexesDict[date], let firstIndex = datesIndexesDict[date.startOfWeek!] else { return nil }
        return mappedIndex(index, firstIndex: firstIndex)
    }

    func day(for indexPath: IndexPath) -> Int {
        let indexPathWithOffset = IndexPath(row: indexPath.row - 7, section: 0)
        guard let dateIndex = datesIndexesDict.first(where: { $0.value == indexPathWithOffset.row }) else { return 0 }
        return dateIndex.key.day
    }

    private func updateWeeksForDate(_ date: Date) {
        lastWeekDates = lastWeekDatesFrom(date)
        currentWeekDates = currentWeekDatesFrom(date)
        nextWeekDates = nextWeekDatesFrom(date)
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

    func indexes(of dates: [Date]) -> [Int] {
        var indexes: [Int] = []
        for date in dates {
            guard let index = datesIndexesDict[date] else { continue }
            indexes.append(mappedIndex(index, firstIndex: datesIndexesDict[dates.first!]!))
        }
        return indexes
    }

    private func mappedIndex(_ index: Int, firstIndex: Int) -> Int {
        if index >= 0 {
            return index + MoodLogViewModel.offset
        }
        return index - firstIndex + MoodLogViewModel.offset - 1
    }

    private func updateDatesIndexes(dates: [Date], offset: Int) {
        hasNewDates = false

        for (i, date) in dates.enumerated() {
            guard datesIndexesDict[date] == nil else { continue }
            if offset > 0 {
                datesIndexesDict[date] = i + offset
            } else {
                datesIndexesDict[date] = i - MoodLogViewModel.offset + offset
            }
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

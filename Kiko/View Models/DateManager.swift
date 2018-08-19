import KikoModels
import KikoUIKit

protocol DateManageable {

    var month: Month { get }
    var numberOfDays: Int { get }
    func numberOf(day: Day) -> Int

}

class DateManager: DateManageable {

    var month: Month
    private let date: Date
    private lazy var calendar: Calendar = {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        return gregorianCalendar
    }()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()

    var numberOfDays: Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return unwrapOrEmpty(range?.count)
    }

    init(date: Date) {
        self.date = date
        self.month = date.month
    }

    convenience init(month: Month, year: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: "01-\(month)-\(year)") ?? Date()
        self.init(date: date)
        self.month = month
    }

    func numberOf(day: Day) -> Int {
        var countOfDays = 0
        var dateComponents = DateComponents()
        for currentDay in 1...numberOfDays {
            dateComponents.day = currentDay
            dateComponents.month = month.rawValue
            dateComponents.year = date.year
            guard let date = calendar.date(from: dateComponents) else { continue }
            let dayOfWeek = dateFormatter.string(from: date)
            if dayOfWeek == day.rawValue {
                countOfDays += 1
            }
        }
        return countOfDays
    }
}

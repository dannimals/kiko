import KikoModels
import KikoUIKit

protocol DateManageable {
    func numberOf(day: Day) -> Int
    var numberOfDays: Int { get }
}

class DateManager: DateManageable {
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

    lazy var numberOfDays: Int = {
        let range = calendar.range(of: .day, in: .month, for: date)
        return unwrapOrEmpty(range?.count)
    }()

    init(date: Date) {
        self.date = date
    }

    func numberOf(day: Day) -> Int {
        var countOfDays = 0
        var dateComponents = DateComponents()

        for currentDay in 1...numberOfDays {
            dateComponents.day = currentDay
            guard let date = calendar.date(from: dateComponents) else { continue }
            let dayOfWeek = dateFormatter.string(from: date)
            if dayOfWeek == day.rawValue {
                countOfDays += 1
            }
        }
        return countOfDays
    }
}

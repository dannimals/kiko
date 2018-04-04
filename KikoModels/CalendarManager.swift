
enum Month: Int {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
}

struct CalendarManager {

    public var currentMonth: Month {
        let date = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        guard let month = Month(rawValue: currentMonth) else { return .january }
        return month
    }

    public var currentDay: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    public var daysOfYear: Int {
        guard isLeapYear else { return 365 }
        return 366
    }

    public func monthBefore(_ month: Month) -> Month {
        guard month != .january else { return .december }

        let monthBefore = month.rawValue - 1
        guard let month = Month(rawValue: monthBefore) else { return .january }
        return month
    }

    public func monthAfter(_ month: Month) -> Month {
        guard month != .december else { return .january }

        let nextMonth = month.rawValue + 1
        guard let month = Month(rawValue: nextMonth) else { return .january }
        return month
    }

    public func numberOfDaysIn(_ month: Month) -> Int {
        switch month {
        case .january, .march, .may, .july, .august, .october, .december:
            return 31
        case .february:
            guard isLeapYear else { return 28 }
            return 29
        case .april, .june, .september, .november:
            return 30
        }
    }

    var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }

    var isLeapYear: Bool {
        return (currentYear % 4 == 0) && (currentYear % 100 != 0) || (currentYear % 400 == 0)
    }
}

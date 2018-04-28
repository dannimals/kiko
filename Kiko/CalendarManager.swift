
import KikoModels

final class CalendarManager {

    var startOfWeekDay: Int {
        guard let startofWeekDate = Date().startOfWeek else { return 0 }
        let component = Calendar.Component.day
        let day = Calendar.current.component(component, from: startofWeekDate)
        return day
    }

    var endOfWeekDay: Int {
        guard let endOfWeekDate = Date().endOfWeek else { return 0 }
        let component = Calendar.Component.day
        let day = Calendar.current.component(component, from: endOfWeekDate)
        return day
    }

    var currentDay: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }

    var daysOfYear: Int {
        guard isLeapYear else { return 365 }
        return 366
    }

    func lastStartOfWeekDay(date: Date) -> Int {
        guard let startofWeekDate = date.startOfWeek else { return 0 }
        let component = Calendar.Component.day
        let day = Calendar.current.component(component, from: startofWeekDate)
        return day
    }

    func monthBefore(_ month: Month) -> Month {
        guard month != .january else { return .december }

        let monthBefore = month.rawValue - 1
        guard let month = Month(rawValue: monthBefore) else { return .january }
        return month
    }

    func monthAfter(_ month: Month) -> Month {
        guard month != .december else { return .january }

        let nextMonth = month.rawValue + 1
        guard let month = Month(rawValue: nextMonth) else { return .january }
        return month
    }

    func numberOfDaysIn(_ month: Month) -> Int {
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

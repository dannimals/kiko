
public extension Date {

    public var day: Int {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        return gregorianCalendar.component(.day, from: self)
    }

    public var month: Month {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let monthRaw = gregorianCalendar.component(.month, from: self)
        guard let month = Month(rawValue: monthRaw) else { return .january }
        return month
    }

    public func daysSince(_ date: Date) -> Int {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        return gregorianCalendar.dateComponents([.day], from: self, to: date).day ?? 0
    }

    public func dateFromAddingDays(_ days: Int) -> Date {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = days
        guard let dateFromAddingDays = gregorianCalendar.date(byAdding: dateComponents, to: self) else { return self }
        return dateFromAddingDays
    }

    public var lastStartOfWeek: Date {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = -7
        guard let startOfWeek = self.startOfWeek, let lastSunday = gregorianCalendar.date(byAdding: dateComponents, to: startOfWeek) else { return Date() }
        return lastSunday
    }

    public var nextStartOfWeek: Date {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.day = 7
        guard let startOfWeek = self.startOfWeek, let lastSunday = gregorianCalendar.date(byAdding: dateComponents, to: startOfWeek) else { return Date() }
        return lastSunday
    }

    public var startOfWeek: Date? {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        guard let sunday = gregorianCalendar.date(from: gregorianCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return sunday
    }

    public var endOfWeek: Date? {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        guard let sunday = gregorianCalendar.date(from: gregorianCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorianCalendar.date(byAdding: .day, value: 6, to: sunday)
    }

}

import KikoModels
import KikoUIKit
@testable import Kiko

class MockDateManager: DateManaging {

    var month: Month { return Month.august }
    var numberOfDays = 31
    func numberOf(day: Day) -> Int {
        switch day {
        case .sunday:
            return 4
        case .monday:
            return 4
        case .tuesday:
            return 4
        case .wednesday:
            return 5
        case .thursday:
            return 5
        case .friday:
            return 5
        case .saturday:
            return 4
        }
    }
}

import KikoModels

class MonthData {
    typealias MoodCount = [MoodType: Int]

    let dateManager: DateManager

    var month: Month {
        return dateManager.month
    }

    let countOfMon: MoodCount
    let countOfTues: MoodCount
    let countOfWed: MoodCount
    let countOfThurs: MoodCount
    let countOfFri: MoodCount
    let countOfSat: MoodCount
    let countOfSun: MoodCount

    init(dateManager: DateManager,
         countOfMon: MoodCount,
         countOfTues: MoodCount,
         countOfWed: MoodCount,
         countOfThurs: MoodCount,
         countOfFri: MoodCount,
         countOfSat: MoodCount,
         countOfSun: MoodCount) {
        self.dateManager = dateManager
        self.countOfMon = countOfMon
        self.countOfTues = countOfTues
        self.countOfWed = countOfWed
        self.countOfThurs = countOfThurs
        self.countOfFri = countOfFri
        self.countOfSat = countOfSat
        self.countOfSun = countOfSun
    }

    lazy var totalDays: Int = {
        return dateManager.numberOfDays
    }()

    func countOf(day: Day) -> Int {
        return dateManager.numberOf(day: day)
    }

    func moodCountOf(day: Day) -> MoodCount {
        switch day {
        case .monday:
            return countOfMon
        case .tuesday:
            return countOfTues
        case .wednesday:
            return countOfWed
        case .thursday:
            return countOfThurs
        case .friday:
            return countOfFri
        case .saturday:
            return countOfSat
        case .sunday:
            return countOfSun
        }
    }

    func countOf(moodType: MoodType) -> Int {
        return unwrapOrEmpty(countOfMon[moodType])
            + unwrapOrEmpty(countOfTues[moodType])
            + unwrapOrEmpty(countOfWed[moodType])
            + unwrapOrEmpty(countOfThurs[moodType])
            + unwrapOrEmpty(countOfFri[moodType])
            + unwrapOrEmpty(countOfSat[moodType])
            + unwrapOrEmpty(countOfSun[moodType])
    }

}

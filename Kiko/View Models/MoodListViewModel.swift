import KikoModels

class MoodListViewModel {

    let moodManager: MoodManager

    init(moodManager: MoodManager) {
        self.moodManager = moodManager
    }

    func numberOfSections() -> Int {
        let distinctYears = moodManager.moods.distinct(by: ["year"])
//        return distinctYears.count
        return 2
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        // number of recorded months in year
        return 2
    }

    var randomInt: Int {
        return Int(arc4random_uniform(5))
    }
    func dataForItemAt(_ indexPath: IndexPath) -> MonthData {
        var countOfMon: MonthData.MoodCount = [:]
        countOfMon[.chickEgg] = randomInt
        countOfMon[.egg] = 4 - countOfMon[.chickEgg]!
        countOfMon[.rottenEgg] = 4 - countOfMon[.chickEgg]! - countOfMon[.egg]!

        var countOfTues: MonthData.MoodCount = [:]
        countOfTues[.egg] = randomInt
        countOfTues[.rottenEgg] = 4 - countOfTues[.egg]!

        var countOfWed: MonthData.MoodCount = [:]
        countOfWed[.chick] = randomInt
        countOfWed[.chickEgg] = 4 - countOfWed[.chick]!
        countOfWed[.egg] = 4 - countOfWed[.chick]! - countOfWed[.chickEgg]!

        var countOfThurs: MonthData.MoodCount = [:]
        countOfThurs[.chick] = randomInt

        var countOfFri: MonthData.MoodCount = [:]
        countOfFri[.chick] = randomInt
        countOfFri[.egg] = 4 - countOfFri[.chick]!

        var countOfSat: MonthData.MoodCount = [:]
        countOfSat[.chickEgg] = randomInt

        var countOfSun: MonthData.MoodCount = [:]
        countOfSun[.rottenEgg] = randomInt

        let monthData = MonthData(countOfMon: countOfMon,
                                  countOfTues: countOfTues,
                                  countOfWed: countOfWed,
                                  countOfThurs: countOfThurs,
                                  countOfFri: countOfFri,
                                  countOfSat: countOfSat,
                                  countOfSun: countOfSun,
                                  totalDays: 31, month: .june)
        return monthData
    }
}

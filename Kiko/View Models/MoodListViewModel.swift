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

    func dataForItemAt(_ indexPath: IndexPath) -> MonthData {
        var countOfMon: MonthData.MoodCount = [:]
        countOfMon[.chickEgg] = 2
        countOfMon[.egg] = 1
        countOfMon[.rottenEgg] = 2

        var countOfTues: MonthData.MoodCount = [:]
        countOfTues[.egg] = 1
        countOfTues[.rottenEgg] = 2

        var countOfWed: MonthData.MoodCount = [:]
        countOfWed[.chick] = 1
        countOfWed[.chickEgg] = 2
        countOfWed[.egg] = 1

        var countOfThurs: MonthData.MoodCount = [:]
        countOfThurs[.chick] = 1

        var countOfFri: MonthData.MoodCount = [:]
        countOfFri[.chick] = 3
        countOfFri[.egg] = 1

        var countOfSat: MonthData.MoodCount = [:]
        countOfSat[.chickEgg] = 2

        var countOfSun: MonthData.MoodCount = [:]
        countOfSun[.rottenEgg] = 2

        let monthData = MonthData(countOfMon: countOfMon,
                                  countOfTues: countOfTues,
                                  countOfWed: countOfWed,
                                  countOfThurs: countOfThurs,
                                  countOfFri: countOfFri,
                                  countOfSat: countOfSat,
                                  countOfSun: countOfSun,
                                  totalDays: 31)
        return monthData
    }
}

import KikoModels

class MoodListViewModel {

    let moodManager: MoodManager

    init(moodManager: MoodManager) {
        self.moodManager = moodManager
    }

    func numberOfSections() -> Int {
        return moodManager.countOfDistinctYears
    }

    lazy var distinctYears: [Int] = {
        return moodManager.distinctYears
    }()

    func numberOfItemsInSection(_ section: Int) -> Int {
        let year = distinctYears[section]
        let moodsWithYear = moodManager.moods.filter("year == %@", year)
        let months = moodsWithYear.distinct(by: ["month"])
        return months.count
    }

    var randomInt: Int {
        return Int(arc4random_uniform(5))
    }

    func dataForItemAt(_ indexPath: IndexPath) -> MonthData {
        let year = distinctYears[indexPath.section]
        let moodsWithYear = moodManager.moods.filter("year == %@", year)
        let months = moodsWithYear.distinct(by: ["month"])
        let month = Month(rawValue: months[indexPath.row].month) ?? .january
        let dateManager = DateManager(month: month, year: year)

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

        // need a filter on day as well behhh

        let monthData = MonthData(dateManager: dateManager,
                                  countOfMon: countOfMon,
                                  countOfTues: countOfTues,
                                  countOfWed: countOfWed,
                                  countOfThurs: countOfThurs,
                                  countOfFri: countOfFri,
                                  countOfSat: countOfSat,
                                  countOfSun: countOfSun)
        return monthData
    }
}

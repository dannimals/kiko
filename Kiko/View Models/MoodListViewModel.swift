import KikoModels

class MoodListViewModel {

    let moodManager: MoodManaging

    init(moodManager: MoodManaging) {
        self.moodManager = moodManager
    }

    func numberOfSections() -> Int {
        return moodManager.countOfDistinctYears
    }

    lazy var distinctYears: [Int] = {
        return moodManager.distinctYears.sorted()
    }()

    func numberOfItemsInSection(_ section: Int) -> Int {
        let moodsWithYear = moodManager.moods.filter("year == %@", distinctYears[section])
        let months = moodsWithYear.distinct(by: ["month"])
        return months.count
    }

    func monthOfItem(at indexPath: IndexPath) -> Month? {
        let year = distinctYears[indexPath.section]
        let moodsWithYear = moodManager.moods.filter("year == %@", year)
        let moodsWithDistinctMonth = moodsWithYear.distinct(by: ["month"])
        let monthValue = moodsWithDistinctMonth[indexPath.row].month
        return Month(rawValue: unwrapOrElse(monthValue, fallback: 1))
    }

    var randomInt: Int {
        return Int(arc4random_uniform(5))
    }

    func dataForItemAt(_ indexPath: IndexPath) -> MonthData {
        let year = distinctYears[indexPath.section]
        guard let month = monthOfItem(at: indexPath) else { fatalError("cannot find month data for item at indexPath \(indexPath)")}
        let dateManager = DateManager(month: month, year: year)
        let moodTypesInMonth = moodManager.moodTypes(month: month, year: year)

        let countOfMon: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.monday], fallback: [:])
        let countOfTues: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.tuesday], fallback: [:])
        let countOfWed: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.wednesday], fallback: [:])
        let countOfThurs: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.thursday], fallback: [:])
        let countOfFri: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.friday], fallback: [:])
        let countOfSat: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.saturday], fallback: [:])
        let countOfSun: MonthData.MoodCount = unwrapOrElse(moodTypesInMonth[.sunday], fallback: [:])

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

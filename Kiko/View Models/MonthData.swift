import KikoModels

struct MonthData {
    typealias MoodCount = [MoodType: Int]

    let countOfMon: MoodCount
    let countOfTues: MoodCount
    let countOfWed: MoodCount
    let countOfThurs: MoodCount
    let countOfFri: MoodCount
    let countOfSat: MoodCount
    let countOfSun: MoodCount
    let totalDays: Int
    let month: Month

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

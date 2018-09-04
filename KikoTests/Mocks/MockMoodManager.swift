import KikoModels
import KikoUIKit
import RealmSwift

class MockMoodManager: MoodManaging {

    let realm: Realm

    init() {
        self.realm = try! Realm()
    }

    var hasMoodForToday = true

    func mood(forDate date: Date) -> Mood? {
        let yearPredicate = NSPredicate(format: "year = \(date.year)")
        let monthPredicate = NSPredicate(format: "month = \(date.month.rawValue)")
        let dayPredicate = NSPredicate(format: "day = \(date.day)")
        let query = NSCompoundPredicate(type: .and, subpredicates: [yearPredicate, monthPredicate, dayPredicate])
        return moods.filter(query).first
    }

    func save(_ mood: Mood) throws {
        try? realm.write {
            realm.add(mood)
        }
    }

    func deleteAll() throws {
        try? realm.write {
            realm.deleteAll()
        }
    }

    public func moodTypes(month: Month, year: Int) -> [Weekday: [MoodType: Int]] {
        let yearPredicate = NSPredicate(format: "year = \(year)")
        let monthPredicate = NSPredicate(format: "month = \(month.rawValue)")
        let query = NSCompoundPredicate(type: .and, subpredicates: [yearPredicate, monthPredicate])
        let filteredMoods = moods.filter(query)
        var monthData = [Weekday: [MoodType: Int]]()

        for i in 1...7 {
            var moodTypes = [MoodType: Int]()
            guard let weekday = Weekday(rawValue: i) else { break }
            let weekdayPredicate = NSPredicate(format: "weekday = \(i)")
            for j in 0...3 {
                guard let moodType = MoodType(rawValue: j) else { break }
                let moodPredicate = NSPredicate(format: "type = \(j)")
                let query = NSCompoundPredicate(type: .and, subpredicates: [moodPredicate, weekdayPredicate])
                let moodsOnWeekdayCount = filteredMoods.filter(query).count
                moodTypes[moodType] = moodsOnWeekdayCount
            }
            monthData[weekday] = moodTypes
        }

        return monthData
    }

    var countOfDistinctYears: Int {
        return moods.distinct(by: ["year"]).count
    }

    var distinctYears: [Int] {
        guard let years = moods.value(forKey: "year") as? [Int] else { return [] }
        let distinctYears = Set(years)
        return Array(distinctYears.sorted())
    }

    var moods: Results<Mood> {
        return realm.objects(Mood.self).sorted(byKeyPath: Mood.Property.date.rawValue)
    }
}

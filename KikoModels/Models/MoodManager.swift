import RealmSwift

public protocol MoodManaging {
    func save(_ mood: Mood) throws
    func deleteAll() throws
    func mood(forDate date: Date) -> Mood?
    func moodTypes(month: Month, year: Int) -> [Weekday: [MoodType: Int]]

    var countOfDistinctYears: Int { get }
    var distinctYears: [Int] { get }
    var moods: Results<Mood> { get }
    var hasMoodForToday: Bool { get }
}

public class MoodManager: MoodManaging {

    public private(set) var moods: Results<Mood>

    public func save(_ mood: Mood) throws {
        try Mood.create(mood)
    }

    public func deleteAll() throws {
        try Mood.deleteAll()
    }

    public var countOfDistinctYears: Int {
        return moods.distinct(by: ["year"]).count
    }

    public var hasMoodForToday: Bool {
        return mood(forDate: Date()) != nil
    }

    public var distinctYears: [Int] {
        guard let years = moods.value(forKey: "year") as? [Int] else { return [] }
        let distinctYears = Set(years)
        return Array(distinctYears.sorted())
    }

    public func mood(forDate date: Date) -> Mood? {
        let yearPredicate = NSPredicate(format: "year = \(date.year)")
        let monthPredicate = NSPredicate(format: "month = \(date.month.rawValue)")
        let dayPredicate = NSPredicate(format: "day = \(date.day)")
        let query = NSCompoundPredicate(type: .and, subpredicates: [yearPredicate, monthPredicate, dayPredicate])
        return moods.filter(query).first
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

    required public init() throws {
        self.moods = try Mood.all()
    }
}

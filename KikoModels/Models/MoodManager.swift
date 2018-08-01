import RealmSwift

public protocol MoodManagerDelegate: class {
    func didReceiveInitialChanges()
    func didReceiveUpdate(deletions: [Int], insertions: [Int], updates: [Int])
}

public class MoodManager {

    weak var delegate: MoodManagerDelegate?
    public private(set) var moods: Results<Mood>
    var moodsNotificationToken: NotificationToken?

    public func save(_ mood: Mood) throws {
        try Mood.create(mood)
    }

    func deleteAll() throws {
        try Mood.deleteAll()
    }

    public func configure(delegate: MoodManagerDelegate) {
        self.delegate = delegate
    }

    public var countOfDistinctYears: Int {
        return moods.distinct(by: ["year"]).count
    }

    public var distinctYears: [Int] {
        guard let years = moods.value(forKey: "year") as? [Int] else { return [] }
        let distinctYears = Set(years)
        return Array(distinctYears.sorted())
    }

    func moodCountFor(type: MoodType, month: Month, year: Int) -> Int {
        guard let moods = try? Mood.all(), moods.count > 0 else { return 0 }

        let moodPredicate = NSPredicate(format: "type == %@", type.rawValue)
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let monthPredicate = NSPredicate(format: "month == %@", month.rawValue)
        let query = NSCompoundPredicate(type: .and, subpredicates: [moodPredicate, yearPredicate, monthPredicate])

        return moods.filter(query).count
    }

    required public init() throws {
        self.moods = try Mood.all()
        self.moodsNotificationToken = moods.observe { changes in
            switch changes {
            case .initial:
                break
//                self.delegate?.didReceiveInitialChanges()
            case let .update(_, deletions, insertions, updates):
                break
//                self.delegate?.didReceiveUpdate(deletions: deletions, insertions: insertions, updates: updates)
            case .error:
                break
            }
        }
    }
}

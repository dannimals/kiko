
import RealmSwift

public protocol MoodManagerDelegate: class {
    func didReceiveInitialChanges()
    func didReceiveUpdate(deletions: [Int], insertions: [Int], updates: [Int])
}

public class MoodManager {

    weak var delegate: MoodManagerDelegate?
    public private(set) var moods: Results<Mood>
    let moodsNotificationToken: NotificationToken!

    func save(_ mood: Mood) throws {
        try Mood.create(mood)
    }

    func deleteAll() throws {
        try Mood.deleteAll()
    }

    func moodCountFor(type: MoodType, month: Month, year: Int) -> Int {
        guard let moods = try? Mood.all(), moods.count > 0 else { return 0 }


        let moodPredicate = NSPredicate(format: "type == %@", type.rawValue)
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let query = NSCompoundPredicate(type: .and, subpredicates: [moodPredicate, yearPredicate])
        
        return moods.filter(query).count
    }

    required public init(delegate: MoodManagerDelegate) throws {
        self.delegate = delegate
        self.moods = try Mood.all()
        self.moodsNotificationToken = moods.observe { changes in
            switch changes {
            case .initial:
                delegate.didReceiveInitialChanges()
            case let .update(_, deletions, insertions, updates):
                delegate.didReceiveUpdate(deletions: deletions, insertions: insertions, updates: updates)
            case .error:
                break
            }
        }
    }
}

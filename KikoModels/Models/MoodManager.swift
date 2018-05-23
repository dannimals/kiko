
import RealmSwift

public protocol MoodManagerDelegate: class {
    func didReceiveInitialChanges()
    func didReceiveUpdate(deletions: [Int], insertions: [Int], updates: [Int])
}

public class MoodManager {

    weak var delegate: MoodManagerDelegate?
    public private(set) var moods: Results<Mood>
    let moodsNotificationToken: NotificationToken!

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


import RealmSwift

@objc public enum MoodType: Int, Codable {
    case chick
    case chickEgg
    case egg
    case rottenEgg
}

@objcMembers public class Mood: Object {
    enum Property: String {
        case id, date, type
    }

    public dynamic let id = UUID().uuidString
    public private(set) dynamic var date: Date = Date()
    public private(set) dynamic var type: MoodType  = .chick

    override public static func primaryKey() -> String? {
        return Mood.Property.id.rawValue
    }

    public convenience init(date: Date, type: MoodType) {
        self.init()

        self.date = date
        self.type = type
    }
}

// MARK: - CRUD methods

public extension Mood {


}

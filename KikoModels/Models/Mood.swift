import RealmSwift

@objc public enum MoodType: Int, Codable {
    case chick
    case chickEgg
    case egg
    case rottenEgg
}

@objcMembers public class Mood: Object {
    public enum Property: String {
        case id, date, type, year, month, weekday, day
    }

    public dynamic var id = UUID().uuidString
    public private(set) dynamic var date: Date = Date()
    public private(set) dynamic var type: Int = 0
    public private(set) dynamic var year: Int = 0
    public private(set) dynamic var month: Int = 0
    public private(set) dynamic var weekday: Int = 0
    public private(set) dynamic var day: Int = 0

    override public static func primaryKey() -> String? {
        return Mood.Property.id.rawValue
    }

    public convenience init(type: MoodType, date: Date) {
        self.init()

        self.date = date
        self.day = date.day
        self.month = date.month.rawValue
        self.type = type.rawValue
        self.year = date.year
        self.weekday = date.weekday
    }
}

// MARK: - CRUD methods

public extension Mood {

    public static func all() throws -> Results<Mood> {
        guard let realm = try? Realm() else { throw KikoModelError.realm("Failed to init Realm") }
        return realm.objects(Mood.self).sorted(byKeyPath: Mood.Property.date.rawValue)
    }

    @discardableResult
    public static func update(_ mood: Mood, withNewMood newMood: Mood) throws -> Mood {
        guard let realm = try? Realm() else { throw KikoModelError.realm("Failed to init Realm") }

        do {
            try realm.write {
                mood.type = newMood.type
                realm.add(mood, update: true)
            }
        } catch {
            throw KikoModelError.realm("Failed to update Mood instance to Realm")
        }

        return mood
    }

    @discardableResult
    public static func create(_ mood: Mood) throws -> Mood {
        guard let realm = try? Realm() else { throw KikoModelError.realm("Failed to init Realm") }

        do {
            try realm.write {
                realm.add(mood, update: true)
            }
        } catch {
            throw KikoModelError.realm("Failed to write Mood instance to Realm")
        }

        return mood
    }

    @discardableResult
    public static func create(type: MoodType, date: Date) throws -> Mood {
        guard let realm = try? Realm() else { throw KikoModelError.realm("Failed to init Realm") }

        let mood = Mood(type: type, date: date)
        do {
            try realm.write {
                realm.add(mood)
            }
        } catch {
            throw KikoModelError.realm("Failed to write Mood instance to Realm")
        }

        return mood
    }

    static func deleteAll() throws {
        guard let realm = try? Realm() else { throw KikoModelError.realm("Failed to init Realm") }

        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            throw KikoModelError.realm("Failed to delete Mood instances in Realm")
        }
    }
}

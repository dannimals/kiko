
public enum MoodType: Int, Codable {
    case chick
    case chickEgg
    case egg
    case rottenEgg
}

public struct Mood: Codable {
    public let date: Date
    public let type: MoodType

    public enum CodingKeys: String, CodingKey {
        case date
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Mood.CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        type = try container.decode(MoodType.self, forKey: .type)
    }
}

extension Mood: Equatable {
    public static func == (lhs: Mood, rhs: Mood) -> Bool {
        return lhs.date == rhs.date && lhs.type == rhs.type
    }
}

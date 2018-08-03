import XCTest
import Foundation
import KikoModels
import RealmSwift
@testable import Kiko

class MoodListViewModelTests: XCTestCase {

    var moodListViewModel: MoodListViewModel?
    var moodManager: MoodManaging?
    lazy var testMood1: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2018-08-02"))
    }()
    lazy var testMood2: Mood = {
        Mood(type: MoodType.chickEgg, date: date(from: "2018-08-1"))
    }()
    lazy var testMood3: Mood = {
        Mood(type: MoodType.rottenEgg, date: date(from: "2018-07-02"))
    }()
    lazy var testMood4: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2017-01-02"))
    }()

    func date(from dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodListViewmodelTestsDatabase"
        self.moodManager = MockMoodManager()
        moodListViewModel = MoodListViewModel(moodManager: moodManager!)
        try! moodManager!.save(testMood1)
        try! moodManager!.save(testMood2)
        try! moodManager!.save(testMood3)
        try! moodManager!.save(testMood4)
    }

    override func tearDown() {
        super.tearDown()

        try? moodManager?.deleteAll()
        moodManager = nil
        moodListViewModel = nil
    }

    func testSetup() {
        guard let moodManager = try? MockMoodManager() else { XCTFail("moodManager fail")}

        XCTAssertNotNil(moodListViewModel!)
        XCTAssertNotNil(moodManager)
        XCTAssertEqual(4, moodManager.moods.count)
    }



}

class MockMoodManager: MoodManaging {
    let realm: Realm

    init() {
        self.realm = try! Realm()
    }

    func save(_ mood: Mood) throws {
        try! realm.write {
            realm.add(mood)
        }
    }

    func deleteAll() throws {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func moodCountFor(type: MoodType, month: Month, year: Int) -> Int {
        guard let moods = try? Mood.all(), moods.count > 0 else { return 0 }

        let moodPredicate = NSPredicate(format: "type == %@", type.rawValue)
        let yearPredicate = NSPredicate(format: "year == %@", year)
        let monthPredicate = NSPredicate(format: "month == %@", month.rawValue)
        let query = NSCompoundPredicate(type: .and, subpredicates: [moodPredicate, yearPredicate, monthPredicate])

        return moods.filter(query).count
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

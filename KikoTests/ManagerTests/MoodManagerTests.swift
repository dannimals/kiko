import XCTest
import Foundation
import KikoModels
import RealmSwift
@testable import Kiko

class MoodManagerTests: XCTestCase {
    lazy var testMood1: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2018-08-01"))
    }()
    lazy var testMood2: Mood = {
        Mood(type: MoodType.chickEgg, date: date(from: "2018-08-02"))
    }()
    lazy var testMood3: Mood = {
        Mood(type: MoodType.rottenEgg, date: date(from: "2018-08-03"))
    }()
    lazy var testMood4: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2017-08-04"))
    }()
    lazy var testMood5: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2016-08-04"))
    }()

    func date(from dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }

    var moodManager: MoodManager!

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodManagerTestsDatabase"
        moodManager = try! MoodManager()
        try? moodManager.save(testMood1)
        try? moodManager.save(testMood2)
        try? moodManager.save(testMood3)
        try? moodManager.save(testMood4)
        try? moodManager.save(testMood5)
    }

    override func tearDown() {
        super.tearDown()

        try? moodManager.deleteAll()
    }

    func testSave() {
        XCTAssertNotNil(moodManager)
        XCTAssertEqual(moodManager.moods.count, 5)
    }

    func testDeleteAll() {
        let initialCount = moodManager.moods.count
        XCTAssertNotEqual(initialCount, 0)
        try? moodManager.deleteAll()
        XCTAssertEqual(moodManager.moods.count, 0)
    }

    func testCountOfDistinctYears() {
        XCTAssertEqual(moodManager.countOfDistinctYears, 3)
        XCTAssertEqual(moodManager.distinctYears, [2016, 2017, 2018])
    }

    func testMoodForDate() {
        let testDate1 = date(from: "2018-08-02")
        let mood = moodManager.mood(forDate: testDate1)
        XCTAssertEqual(mood, testMood2)
        let testDate2 = date(from: "2017-08-04")
        let mood2 = moodManager.mood(forDate: testDate2)
        XCTAssertEqual(mood2, testMood4)
    }

    func testMoodTypes() {
        let moodTypes: [Weekday: [MoodType: Int]] =
            [Weekday.monday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.tuesday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.wednesday:
                [MoodType.chick: 1,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.thursday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 1,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.friday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 1],
             Weekday.saturday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.sunday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0]]
        XCTAssertEqual(moodTypes, moodManager.moodTypes(month: .august, year: 2018))
    }

    func testHasMoodForToday() {
        
    }

}


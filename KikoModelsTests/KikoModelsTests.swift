import XCTest
import RealmSwift
@testable import KikoModels

class MoodTests: XCTestCase {
    var mood: Mood!
    var date = Date()
    let type = MoodType.chick
    let dateFormatter = DateFormatter()

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodTestsDatabase"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        mood = Mood(type: type, date: date)
    }

    override func tearDown() {
        super.tearDown()

        mood = nil
        try! Mood.deleteAll()
    }

    func testAdd() {
        guard let expectedMood = try? Mood.create(type: type, date: date) else { XCTFail(); return }
        XCTAssertEqual(expectedMood.date, date)
        XCTAssertEqual(expectedMood.type, type.rawValue)
    }

    func testUpdate() {
        guard let _ = try? Mood.create(type: .egg, date: date) else { XCTFail(); return }
        guard let expectedMood = try? Mood.create(type: .rottenEgg, date: date) else { XCTFail(); return }
        XCTAssertEqual(expectedMood.date, date)
        XCTAssertEqual(expectedMood.type, MoodType.rottenEgg.rawValue)
    }

    func testAll() {
        var allMoods = try! Mood.all()
        XCTAssertTrue(allMoods.isEmpty)
        try! Mood.create(type: type, date: date)
        allMoods = try! Mood.all()
        XCTAssertEqual(allMoods.count, 1)
    }

    func testDeleteAll() {
        try! Mood.create(type: type, date: date)
        var allMoods = try! Mood.all()
        XCTAssertEqual(allMoods.count, 1)
        try! Mood.deleteAll()
        allMoods = try! Mood.all()
        XCTAssertTrue(allMoods.isEmpty)
    }

    func testDistinctYear() {
        try! Mood.create(type: type, date: date)
        try! Mood.create(type: type, date: dateFormatter.date(from: "1995-04-21")!)
        let allMoods = try! Mood.all()
        let distinctYearMoods = allMoods.distinct(by: ["year"])
        XCTAssertEqual(distinctYearMoods.count, 2)
        XCTAssertEqual(distinctYearMoods.first!.year, 1995)
        XCTAssertEqual(distinctYearMoods.last!.year, 2018)
    }
}

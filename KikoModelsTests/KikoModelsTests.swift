
import XCTest
@testable import KikoModels

class MoodTests: XCTestCase {
    var mood: Mood!
    let date = Date()
    let type = MoodType.chick
    
    override func setUp() {
        super.setUp()

        mood = Mood(type: type, date: date)
    }
    
    override func tearDown() {
        super.tearDown()

        mood = nil
        try! Mood.deleteAll()
    }

    func testAdd() {
        let otherMood = try! Mood.add(type: type, date: date)
        XCTAssertEqual(otherMood.date, date)
        XCTAssertEqual(otherMood.type, type)
    }

    func testAll() {
        var allMoods = try! Mood.all()
        XCTAssertTrue(allMoods.isEmpty)
        try! Mood.add(type: type, date: date)
        allMoods = try! Mood.all()
        XCTAssertEqual(allMoods.count, 1)
    }

    func testDeleteAll() {
        try! Mood.add(type: type, date: date)
        var allMoods = try! Mood.all()
        XCTAssertEqual(allMoods.count, 1)
        try! Mood.deleteAll()
        allMoods = try! Mood.all()
        XCTAssertTrue(allMoods.isEmpty)
    }
}

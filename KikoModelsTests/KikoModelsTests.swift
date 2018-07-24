import XCTest
@testable import KikoModels

class MoodTests: XCTestCase {
    var mood: Mood!
    var date = Date()
    let type = MoodType.chick
    let dateFormatter = DateFormatter()

    override func setUp() {
        super.setUp()

        dateFormatter.dateFormat = "yyyy-MM-dd"
//        date = dateFormatter.date(from: "2018-04-21")
        mood = Mood(type: type, date: date)
    }

    override func tearDown() {
        super.tearDown()

        mood = nil
//        date = nil
        try! Mood.deleteAll()
    }

    func testAdd() {
        let otherMood = try! Mood.create(type: type, date: date)
        XCTAssertEqual(otherMood.date, date)
        XCTAssertEqual(otherMood.type, type)
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

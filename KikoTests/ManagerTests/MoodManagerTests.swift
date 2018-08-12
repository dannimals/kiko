//import XCTest
//import Foundation
//import KikoModels
//import RealmSwift
//@testable import Kiko
//
//class MoodManagerTests: XCTestCase {
//    lazy var testMood1: Mood = {
//        Mood(type: MoodType.chick, date: date(from: "2018-08-01"))
//    }()
//    lazy var testMood2: Mood = {
//        Mood(type: MoodType.chickEgg, date: date(from: "2018-08-2"))
//    }()
//    lazy var testMood3: Mood = {
//        Mood(type: MoodType.rottenEgg, date: date(from: "2018-08-03"))
//    }()
//    lazy var testMood4: Mood = {
//        Mood(type: MoodType.chick, date: date(from: "2017-08-04"))
//    }()
//    lazy var testMood5: Mood = {
//        Mood(type: MoodType.chick, date: date(from: "2016-08-04"))
//    }()
//
//    func date(from dateString: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.date(from: dateString)!
//    }
//
//    let moodManager = try! MoodManager()
//
//    func setup() {
//        super.setUp()
//
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodManagerTestsDatabase"
//        try? moodManager.save(testMood1)
//        try? moodManager.save(testMood2)
//        try? moodManager.save(testMood3)
//        try? moodManager.save(testMood4)
//        try? moodManager.save(testMood5)
//    }
//
//    override func tearDown() {
//        super.tearDown()
//
////        try? moodManager.deleteAll()
//    }
//
//    func testSave() {
//        XCTAssertNotNil(moodManager)
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodManagerTestsDatabase"
//        try! moodManager.save(testMood1)
//        try! moodManager.save(testMood2)
//        try! moodManager.save(testMood3)
//        try! moodManager.save(testMood4)
//        try! moodManager.save(testMood5)
//        XCTAssertEqual(moodManager.moods.count, 3)
//    }
//
//    func testDeleteAll() {
//        let moodCount = moodManager.moods.count
//        XCTAssertNotEqual(moodCount, 0)
//        try? moodManager.deleteAll()
//        XCTAssertEqual(moodCount, 0)
//    }
//
//    func testCountOfDistinctYears() {
//        XCTAssertEqual(moodManager.countOfDistinctYears, 1)
//    }
//    
//}
//

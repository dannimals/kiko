import XCTest
import Foundation
import KikoModels
import RealmSwift
@testable import Kiko

class MoodListViewModelTests: XCTestCase {

    var moodListViewModel: MoodListViewModel?
    var moodManager: MoodManaging?
    lazy var testMood1: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2018-08-02")) // Thursday
    }()
    lazy var testMood2: Mood = {
        Mood(type: MoodType.chickEgg, date: date(from: "2018-08-1")) // Wednesday
    }()
    lazy var testMood3: Mood = {
        Mood(type: MoodType.rottenEgg, date: date(from: "2018-07-02"))
    }()
    lazy var testMood4: Mood = {
        Mood(type: MoodType.chick, date: date(from: "2017-01-02"))
    }()

    func date(from dateString: String) -> Date {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = gregorianCalendar
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
    }

    override func setUp() {
        super.setUp()

        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "MoodListViewmodelTestsDatabase"
        self.moodManager = MockMoodManager()
        moodListViewModel = MoodListViewModel(moodManager: moodManager!)
        try? moodManager!.save(testMood1)
        try? moodManager!.save(testMood2)
        try? moodManager!.save(testMood3)
        try? moodManager!.save(testMood4)
    }

    override func tearDown() {
        super.tearDown()

        try? moodManager?.deleteAll()
        moodManager = nil
        moodListViewModel = nil
    }

    func testSetup() {
        guard let _ = moodListViewModel, let moodManager = moodManager else { XCTFail("moodListViewModel is nil"); return }
        XCTAssertEqual(4, moodManager.moods.count)
    }

    func testComputedProperties() {
        guard let moodListViewModel = moodListViewModel else { XCTFail("moodListViewModel is nil"); return }
        XCTAssertEqual(2, moodListViewModel.distinctYears.count)
        XCTAssertEqual([2017, 2018], moodListViewModel.distinctYears)
    }

    func testNumberOfSections() {
        guard let moodListViewModel = moodListViewModel else { XCTFail("moodListViewModel is nil"); return }
        XCTAssertEqual(moodListViewModel.numberOfSections(), 2)
    }

    func testNumberOfItemsInSection() {
        guard let moodListViewModel = moodListViewModel else { XCTFail("moodListViewModel is nil"); return }
        XCTAssertEqual(moodListViewModel.numberOfItemsInSection(0), 1)
        XCTAssertEqual(moodListViewModel.numberOfItemsInSection(1), 2)
    }

    func testMonthOfItemAtIndexPath() {
        guard let moodListViewModel = moodListViewModel else { XCTFail("moodListViewModel is nil"); return }
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertEqual(moodListViewModel.monthOfItem(at: indexPath), Month.january)
    }

    func testMoodTypes() {
        guard let moodManager = moodManager else { XCTFail("moodListViewModel is nil"); return }
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
                [MoodType.chick: 0,
                 MoodType.chickEgg: 1,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.thursday:
                [MoodType.chick: 1,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
             Weekday.friday:
                [MoodType.chick: 0,
                 MoodType.chickEgg: 0,
                 MoodType.egg: 0,
                 MoodType.rottenEgg: 0],
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

}

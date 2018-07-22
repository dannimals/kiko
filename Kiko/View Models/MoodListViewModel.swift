import KikoModels

class MoodListViewModel {

    let moodManager: MoodManager

    init(moodManager: MoodManager) {
        self.moodManager = moodManager
    }

    func numberOfSections() -> Int {
        let distinctYears = moodManager.moods.distinct(by: ["year"])
//        return distinctYears.count
        return 2
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        return 2
    }
}

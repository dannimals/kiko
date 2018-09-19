import KikoModels
import KikoUIKit

class CreateMoodViewController: BaseViewController {

    private var currentMoodType: MoodType = .chick
    private var moodManager: MoodManaging!
    private var moodNavigationCoordinator: MoodCoordinating!
    private var calendarManager: CalendarManaging!

    func configure(moodNavigationCoordinator: MoodCoordinating, calendarManager: CalendarManaging, moodManager: MoodManaging) {

        self.moodManager = moodManager
        self.moodNavigationCoordinator = moodNavigationCoordinator
        self.calendarManager = calendarManager
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let calendarViewController = destination as? CalendarViewController {
            calendarViewController.configure(calendarManager: calendarManager, moodManager: moodManager)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
//        updateViewForCurrentMood()
    }

//    private func updateViewForCurrentMood() {
//        guard let todayMood = moodManager.mood(forDate: Date()) else {
//            moodLogView.reset()
//            return
//        }
//        moodLogView.updateViewForMood(todayMood)
//    }


    private func setupBindings() {
//        moodLogView
//            .ringButtonTapped
//            .subscribe(self) { [unowned self] _ in
//                self.moodNavigationCoordinator.start()
//        }
//        moodLogView
//            .moodChanged
//            .subscribe(self) { [unowned self] moodSetting in
//                self.currentMoodType = self.moodType(from: moodSetting)
//        }
//        moodLogView
//            .wavesButtonTapped
//            .subscribe(self) { [unowned self] _ in
//                self.moodNavigationCoordinator.showWavesViewController()
//        }
//        moodLogView
//            .logButtonTapped
//            .subscribe(self) { _ in
//                self.saveMood()
//                self.moodLogView.reloadDatesCollectionView()
//        }

    }

    private func moodType(from setting: MoodUISetting) -> MoodType {
        guard let moodType = MoodType(rawValue: setting.rawValue) else { return MoodType.chick }
        return  moodType
    }

//    private func updateViewForSavedMood(_ mood: Mood) {
//        moodLogView.updateViewForMood(mood)
//    }

    private func saveMood() {
        let mood = Mood(type: currentMoodType, date: Date())
        guard let color = MoodUISetting(rawValue: mood.type)?.accessoryColor else { return }
        do {
            try moodManager.save(mood)
            presentModalForSuccess(imageColor: color)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                self.updateViewForSavedMood(mood)
            }
        } catch {
            presentModalForFailure(withError: nil, message: Glossary.moodSaveFailureMessage.rawValue)
        }
    }

    private func setupViews() {
        view.backgroundColor = .backgroundYellow
    }

}

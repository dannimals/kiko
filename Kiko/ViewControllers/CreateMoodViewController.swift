import KikoModels
import KikoUIKit

class CreateMoodViewController: BaseViewController {

    private var currentMoodType: MoodType = .chick
    private var moodManager: MoodManaging!
    private var menuNavigationCoordinator: MenuNavigationCoordinating!
    private var calendarManager: CalendarManaging!
    private var calendarViewController: CalendarViewController?
    @IBOutlet weak var logButton: RoundedButton!

    func configure(menuNavigationCoordinator: MenuNavigationCoordinating,
                   calendarManager: CalendarManaging,
                   moodManager: MoodManaging) {
        self.moodManager = moodManager
        self.menuNavigationCoordinator = menuNavigationCoordinator
        self.calendarManager = calendarManager
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        switch destination {
        case let destination as CalendarViewController:
            destination.configure(calendarManager: calendarManager, moodManager: moodManager)
            calendarViewController = destination
        case let destination as PagingViewController:
            _ = destination.view
            destination.configure(delegate: self, viewModel: MoodPageViewModel())
        default: break
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

    }

    @IBAction func logButtonTapped(_ sender: Any) {
        saveMood()
        calendarViewController?.reloadDates(animated: false)
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
        logButton.setTitle(Glossary.log.rawValue, for: .normal)
        logButton.backgroundColor = .cornflowerYellow
    }
}

extension CreateMoodViewController: MoodPagingDelegate {

    func pagingViewDidScroll(_ pagingView: MoodPagingView, page: MoodPageDisplayable) {
        calendarViewController?.updateColor(page.accessoryColor)
        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = page.primaryColor
            self.logButton.backgroundColor = page.accessoryColor
            self.logButton.highlightedBackgroundColor = page.selectedColor
        }
    }
}

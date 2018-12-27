import KikoModels
import KikoUIKit

struct CreateMoodViewState {
    enum Message {
        case moodChanged(MoodType)
    }

    var moodType: MoodType { return moodPage.moodType }
    private var moodPage: MoodPageDisplay = MoodPageDisplay(type: .chick)

    mutating func send(_ message: Message) {
        switch message {
        case let .moodChanged(moodType):
            moodPage = MoodPageDisplay(type: moodType)
        }
    }
}

class CreateMoodViewController: BaseViewController {

    @IBOutlet weak var contentView: CreateMoodView!
    private var state = CreateMoodViewState() {
        didSet { updateViews() }
    }
    private var moodManager: MoodManaging!
    private var menuNavigationCoordinator: MenuNavigationCoordinating!
    private var calendarManager: CalendarManaging!
    private var calendarViewController: CalendarViewController!

    func configure(menuNavigationCoordinator: MenuNavigationCoordinating,
                   calendarManager: CalendarManaging,
                   moodManager: MoodManaging) {
        self.moodManager = moodManager
        self.menuNavigationCoordinator = menuNavigationCoordinator
        self.calendarManager = calendarManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        updateViews()
        contentView.delegate = self
        setupChildViewControllers()
    }

    private func setupChildViewControllers() {
        calendarViewController = CalendarViewController.initFromStoryboard(StoryboardName.createMood)
        calendarViewController.configure(calendarManager: calendarManager, moodManager: moodManager)
        calendarViewController.willMove(toParentViewController: self)
        calendarViewController.view.stretchToFill(parentView: contentView.calendarContainerView)
        addChildViewController(calendarViewController)
        calendarViewController.didMove(toParentViewController: self)

        let pagingViewController = PagingViewController.initFromStoryboard(StoryboardName.createMood)
        pagingViewController.view.stretchToFill(parentView: contentView.pagingContainerView)
        pagingViewController.configure(viewModel: MoodPageViewModel(), observer: self)
        pagingViewController.willMove(toParentViewController: self)
        addChildViewController(pagingViewController)
        pagingViewController.didMove(toParentViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateLogButton()
    }

    private func updateLogButton() {
        let hasMoodForToday = moodManager.mood(forDate: Date()) != nil
        contentView.updateLogButton(hasMoodForToday: hasMoodForToday)
    }

    private func saveMood() {
        let mood = Mood(type: state.moodType, date: Date())
        let color = MoodPageDisplay(type: state.moodType).accessoryColor
        do {
            try moodManager.save(mood)
            presentModalForSuccess(imageColor: color)
            updateLogButton()
        } catch {
            presentModalForFailure(withError: nil, message: Glossary.moodSaveFailureMessage.rawValue)
        }
    }

    private func updateViews() {
        let page = MoodPageDisplay(type: state.moodType)
        calendarViewController?.updateColor(page.accessoryColor)
        UIView.animate(withDuration: 0.4) {
            self.contentView.updateColorsForPage(page)
        }
    }

}

extension CreateMoodViewController: MoodPagingObserving {

    func moodPageViewModel(_ viewModel: MoodPageViewModel, didUpdateMoodPage page: MoodPageDisplayable) {
        state.send(.moodChanged(page.moodType))
    }
}

extension CreateMoodViewController: CreateMoodViewDelegate {

    func ringButtonTapped(_ button: UIButton) {
        menuNavigationCoordinator.start()
    }
    func wavesButtonTapped(_ button: UIButton) {
        menuNavigationCoordinator.showWavesViewController()
    }
    func logButtonTapped(_ button: UIButton) {
        saveMood()
        calendarViewController?.reloadDates(animated: false)
    }
}

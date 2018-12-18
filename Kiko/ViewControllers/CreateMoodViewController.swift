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

    private var state = CreateMoodViewState() {
        didSet { updateViews() }
    }
    private var moodManager: MoodManaging!
    private var menuNavigationCoordinator: MenuNavigationCoordinating!
    private var calendarManager: CalendarManaging!
    private var calendarViewController: CalendarViewController?
    private let buttonsDrawerView = ButtonsDrawerView()
    private let wavesButton = UIButton()
    private let ringButton = UIButton()

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var logButton: RoundedButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusButtonShadow: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var plusButtonContainer: UIView!

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
            destination.configure(viewModel: MoodPageViewModel(), observer: self)
        default: break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateLogButton()
    }

    private func updateLogButton() {
        let hasMoodForToday = moodManager.mood(forDate: Date()) != nil 
        let logButtonTitle = hasMoodForToday ? Glossary.update.rawValue : Glossary.log.rawValue
        logButton.title = logButtonTitle
    }

    private func setupBindings() {
        wavesButton.addTarget(self, action: #selector(wavesButtonTapped), for: .touchUpInside)
        ringButton.addTarget(self, action: #selector(ringButtonTapped), for: .touchUpInside)
    }
    @IBAction func ringButtonTapped(_ sender: Any) {
        toggleMenu()
        menuNavigationCoordinator.start()
    }
    @IBAction func wavesButtonTapped(_ sender: Any) {
        toggleMenu()
        menuNavigationCoordinator.showWavesViewController()
    }
    @IBAction func logButtonTapped(_ sender: Any) {
        saveMood()
        calendarViewController?.reloadDates(animated: false)
    }
    @IBAction func plusButtonTapped(_ sender: Any) {
        toggleMenu()
    }

    private func toggleMenu() {
        rotatePlusButton()
        toggleBlurView(duration: 0.2)
        buttonsDrawerView.toggle()
    }

    private func toggleBlurView(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.blurView.alpha = 0.8 - self.blurView.alpha
        }
    }

    private func rotatePlusButton() {
        let rotation = plusButton.transform.rotation
        let angle: CGFloat = rotation == 45 ? -45 : 45
        plusButton.rotate(by: angle)
    }

    private func moodType(from setting: MoodUISetting) -> MoodType {
        guard let moodType = MoodType(rawValue: setting.rawValue) else { return MoodType.chick }
        return  moodType
    }

    private func saveMood() {
        let mood = Mood(type: state.moodType, date: Date())
        guard let color = MoodUISetting(rawValue: mood.type)?.accessoryColor else { return }
        do {
            try moodManager.save(mood)
            presentModalForSuccess(imageColor: color)
            updateLogButton()
        } catch {
            presentModalForFailure(withError: nil, message: Glossary.moodSaveFailureMessage.rawValue)
        }
    }

    private func setupViews() {
        setupButtons()
        setupButtonsDrawerView()
        updateViews()
    }

    private func setupButtonsDrawerView() {
        buttonsDrawerView.configure(buttons: [ringButton, wavesButton], initialOffset: plusButtonContainer.bounds.height + 32)
        view.addSubview(buttonsDrawerView)
        buttonsDrawerView.translatesAutoresizingMaskIntoConstraints = false
        buttonsDrawerView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor).isActive = true
        buttonsDrawerView.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor).isActive = true
        view.insertSubview(plusButtonContainer, aboveSubview: buttonsDrawerView)
    }

    private func setupButtons() {
        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.bounds.size = CGSize(width: 40, height: 40)
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.tintColor = .purple02
        wavesButton.bounds.size = CGSize(width: 40, height: 40)
        logButton.backgroundColor = .cornflowerYellow
        plusButton.adjustsImageWhenHighlighted = false
        plusButtonShadow.addShadow()
    }

    private func updateViews() {
        let page = MoodPageDisplay(type: state.moodType)
        calendarViewController?.updateColor(page.accessoryColor)
        UIView.animate(withDuration: 0.4) {
            self.logButton.backgroundColor = page.accessoryColor
            self.logButton.highlightedBackgroundColor = page.selectedColor
            self.gradientView.colors = page.gradientColors
        }
    }

}

extension CreateMoodViewController: MoodPagingObserving {

    func moodPageViewModel(_ viewModel: MoodPageViewModel, didUpdateMoodPage page: MoodPageDisplayable) {
        state.send(.moodChanged(page.moodType))
    }
}

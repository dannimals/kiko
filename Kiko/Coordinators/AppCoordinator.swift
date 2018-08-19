import KikoUIKit
import KikoModels

protocol AppCoordinating {
    func start()
}

class AppCoordinator: AppCoordinating {

    private var viewControllers: [UIViewController] = []

    private let calendarManager: CalendarManaging
    private lazy var mainViewController: UINavigationController = {
        let moodLogViewController = MoodLogViewController(calendarManager: calendarManager, moodManager: moodManager)
        return UINavigationController(rootViewController: moodLogViewController)
    }()
    private let moodManager: MoodManaging
    private let window: UIWindow?

    init(window: UIWindow?, calendarManager: CalendarManaging, moodManager: MoodManaging) {
        self.window = window
        self.calendarManager = calendarManager
        self.moodManager = moodManager
    }

    func start() {
        guard let window = window else { return }
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }

}

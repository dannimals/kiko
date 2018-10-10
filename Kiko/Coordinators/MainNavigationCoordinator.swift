import KikoUIKit
import KikoModels

public protocol AppCoordinating {
    func start()
}

class MainNavigationCoordinator: AppCoordinating {

    let calendarManager: CalendarManaging
    let moodNavigationCoordinator: MoodCoordinating
    let moodManager: MoodManaging
    let window: UIWindow?

    lazy var mainViewController: UINavigationController? = {
        let createMoodViewStoryboard = UIStoryboard(name: StoryboardName.createMoodView.rawValue, bundle: nil)
        guard let navigationController = createMoodViewStoryboard.instantiateInitialViewController() as? UINavigationController,
            let createMoodViewController = navigationController.childViewControllers.first as? CreateMoodViewController else { return nil }
        createMoodViewController.configure(moodNavigationCoordinator: moodNavigationCoordinator, calendarManager: calendarManager, moodManager: moodManager)
        moodNavigationCoordinator.configure(rootViewController: navigationController, moodManager: moodManager)

        return navigationController
    }()

    init(window: UIWindow?, calendarManager: CalendarManaging, moodManager: MoodManaging, moodNavigationCoordinator: MoodCoordinating = MoodNavigationCoordinator()) {
        self.window = window
        self.calendarManager = calendarManager
        self.moodManager = moodManager
        self.moodNavigationCoordinator = moodNavigationCoordinator
    }

    func start() {
        guard let window = window, let mainViewController = mainViewController else { return }

        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }

}

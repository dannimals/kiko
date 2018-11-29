import KikoUIKit
import KikoModels

public protocol AppCoordinating {
    func start()
}

class MainNavigationCoordinator: AppCoordinating {

    let calendarManager: CalendarManaging
    let menuNavigationCoordinator: MenuNavigationCoordinating
    let moodManager: MoodManaging
    let window: UIWindow?

    lazy var mainViewController: UINavigationController? = {
        let createMoodViewStoryboard = UIStoryboard(name: StoryboardName.createMoodView, bundle: nil)
        guard let navigationController = createMoodViewStoryboard.instantiateInitialViewController() as? UINavigationController,
            let createMoodViewController = navigationController.childViewControllers.first as? CreateMoodViewController else { return nil }
        createMoodViewController.configure(menuNavigationCoordinator: menuNavigationCoordinator, calendarManager: calendarManager, moodManager: moodManager)
        menuNavigationCoordinator.configure(rootViewController: navigationController, moodManager: moodManager)

        return navigationController
    }()

    init(window: UIWindow?, calendarManager: CalendarManaging, moodManager: MoodManaging, menuNavigationCoordinator: MenuNavigationCoordinating = MenuNavigationCoordinator()) {
        self.window = window
        self.calendarManager = calendarManager
        self.moodManager = moodManager
        self.menuNavigationCoordinator = menuNavigationCoordinator
    }

    func start() {
        guard let window = window, let mainViewController = mainViewController else { return }

        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }

}

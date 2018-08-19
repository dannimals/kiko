import KikoModels
import KikoUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var mainCoordinator: AppCoordinating? = {
        guard let moodManager = try? MoodManager() else { return nil }
        let calendarManager = CalendarManager(date: Date())
        return MainNavigationCoordinator(window: window, calendarManager: calendarManager, moodManager: moodManager)
    }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        mainCoordinator?.start()
        return true
    }

}

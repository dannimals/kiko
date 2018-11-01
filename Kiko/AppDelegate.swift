
import KikoModels
import KikoUIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var mainCoordinator: AppCoordinating? = {
        guard let moodManager = try? MoodManager() else { return nil }
        let calendarManager = CalendarManager(date: Date())
        return MainNavigationCoordinator(window: window, calendarManager: calendarManager, moodManager: moodManager)
    }()
    lazy var notificationCoordinator: NotificationCoordinating = {
        let notificationHandler = UNUserNotificationCenter.current()
        let coordinator = NotificationCoordinator(notificationHandler: notificationHandler)
        return coordinator
    }()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        mainCoordinator?.start()
        notificationCoordinator.start()
        let notification = Notification(title: "test", subtitle: "testing notification", body: "this is a test")
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 10
        let trigger = NotificationTrigger(triggerType: .calendar(dateComponents, repeats: true))
        notificationCoordinator.add(notification: notification, trigger: trigger)

        return true
    }
}

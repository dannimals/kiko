
import UserNotifications
import KikoModels

protocol NotificationCoordinating: class {
    func start()
    func add(notification: Notification, trigger: NotificationTrigger)
}

protocol NotificationHandling: class {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
    func getNotificationSettings(completionHandler: @escaping (UNNotificationSettings) -> Void)
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
}

struct NotificationTrigger {
    enum TriggerType {
        case timeInterval(TimeInterval, repeats: Bool)
        case calendar(DateComponents, repeats: Bool)
    }

    var trigger: UNNotificationTrigger

    init(triggerType: TriggerType) {
        switch triggerType {
        case let .timeInterval(timeInterval, repeats):
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        case let .calendar(dateComponents, repeats):
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        }
    }
}

extension UNUserNotificationCenter: NotificationHandling {}

struct Notification {

    let content = UNMutableNotificationContent()

    init(title: String, subtitle: String, body: String) {
        content.title = title
        content.subtitle = subtitle
        content.body = body
    }
}

class NotificationCoordinator: NotificationCoordinating {

    private let notificationHandler: NotificationHandling
    private static let notificationID = "com.Kiko.notificationID"

    init(notificationHandler: NotificationHandling) {
        self.notificationHandler = notificationHandler
    }

    func add(notification: Notification, trigger: NotificationTrigger) {
        let request = UNNotificationRequest(identifier: NotificationCoordinator.notificationID, content: notification.content, trigger: trigger.trigger)
        notificationHandler.add(request, withCompletionHandler: nil)
    }

    func start() {
        notificationHandler.getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .authorized else {
                self?.requestAuthorization()
                return
            }
        }
    }

    private func requestAuthorization() {
        notificationHandler.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] didAllow, _ in
            if !didAllow { self?.handleRejectedAuthorization() }
        }
    }

    private func handleRejectedAuthorization() {

    }

}

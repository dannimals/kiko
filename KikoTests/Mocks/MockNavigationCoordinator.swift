import KikoModels
import KikoUIKit
@testable import Kiko

class MockMoodNavigationCoodinator: MoodCoordinating {

    var rootViewController: UINavigationController?
    var moodManager: MoodManaging?

    var isStarted = false
    func start() {
        isStarted = true
    }

    var wavesViewControllerShow = false
    func showWavesViewController() {
        wavesViewControllerShow = true
    }

    func configure(rootViewController: UINavigationController, moodManager: MoodManaging) {
        self.rootViewController = rootViewController
        self.moodManager = moodManager
    }

}

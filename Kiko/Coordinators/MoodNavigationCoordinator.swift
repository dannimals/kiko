import KikoUIKit
import KikoModels

protocol MoodNavigationCoordinating {
    func showWavesViewController()
    func configure(rootViewController: UINavigationController, moodManager: MoodManaging)
}

typealias MoodCoordinating = AppCoordinating & MoodNavigationCoordinating

class MoodNavigationCoordinator: MoodCoordinating {

    private var rootViewController: UINavigationController!
    private var moodManager: MoodManaging!

    func configure(rootViewController: UINavigationController, moodManager: MoodManaging) {
        self.rootViewController = rootViewController
        self.moodManager = moodManager
    }

    func start() {
        guard let rootViewController = rootViewController else { return }

        let viewModel = MoodListViewModel(moodManager: moodManager)
        let moodListViewController = MoodListViewController(viewModel: viewModel)
        let halfModalTransitioningDelegate = HalfModalTransitioningDelegate()
        moodListViewController.modalPresentationStyle = .custom
        moodListViewController.transitioningDelegate = halfModalTransitioningDelegate
        rootViewController.present(moodListViewController, animated: true, completion: nil)
    }

    func showWavesViewController() {
        guard let rootViewController = rootViewController else { return }

        let wavesViewController = WavesViewController()
        rootViewController.pushViewController(wavesViewController, animated: true)
    }
}

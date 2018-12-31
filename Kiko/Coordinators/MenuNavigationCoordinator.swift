import KikoUIKit
import KikoModels

public protocol MenuNavigationCoordinating {
    func configure(rootViewController: UINavigationController, moodManager: MoodManaging)
    func showWavesViewController()
    func start()
}

class MenuNavigationCoordinator: MenuNavigationCoordinating {

    private(set) var rootViewController: UINavigationController!
    private(set) var moodManager: MoodManaging!

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

        let wavesViewController = AnimatedWavesViewController()
        rootViewController.pushViewController(wavesViewController, animated: true)
    }
}

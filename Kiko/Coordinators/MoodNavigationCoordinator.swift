import KikoUIKit
import KikoModels

protocol MoodNavigationCoordinating {
    func showWavesViewController()
}

typealias MoodCoordinating = AppCoordinating & MoodNavigationCoordinating

class MoodNavigationCoordinator: MoodCoordinating {

    private let rootViewController: UIViewController
    private let moodManager: MoodManaging

    init(rootViewController: UIViewController, moodManager: MoodManaging) {
        self.rootViewController = rootViewController
        self.moodManager = moodManager
    }

    func start() {
        let viewModel = MoodListViewModel(moodManager: moodManager)
        let moodListViewController = MoodListViewController(viewModel: viewModel)
        let halfModalTransitioningDelegate = HalfModalTransitioningDelegate()
        moodListViewController.modalPresentationStyle = .custom
        moodListViewController.transitioningDelegate = halfModalTransitioningDelegate
        rootViewController.present(moodListViewController, animated: true, completion: nil)
    }

    func showWavesViewController() {
        let wavesViewController = WavesViewController()
        rootViewController.navigationController?.pushViewController(wavesViewController, animated: true)
    }
}

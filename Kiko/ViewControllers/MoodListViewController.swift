
import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController {
    private let viewModel: MoodListViewModel
    private var emptyStateView: MoodListEmptyStateView?
    private var moodManager: MoodManager?
    private let moodListView: MoodListView = MoodListView.loadFromNib()
    private var dismissInteractor: DismissViewControllerInteractor?

    required init(viewModel: MoodListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = moodListView
        moodListView.configure(dataSource: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        setupDismissGestureRecognizer()
    }

    private func setupDismissGestureRecognizer() {
        let dismissGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(dismissGestureRecognizer)
    }

    @objc private func handleDismiss(sender: UIPanGestureRecognizer) {
        guard let dismissInteractor = dismissInteractor else { return }

        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch sender.state {
        case .began:
            dismissInteractor.hasStartedDismissing = true
            dismiss(animated: true, completion: nil)
        case .changed:
            dismissInteractor.shouldFinishDismissing = progress > percentThreshold
            dismissInteractor.update(progress)
        case .cancelled:
            dismissInteractor.hasStartedDismissing = false
            dismissInteractor.cancel()
        case .ended:
            dismissInteractor.hasStartedDismissing = false
            dismissInteractor.shouldFinishDismissing
                ? dismissInteractor.finish()
                : dismissInteractor.cancel()
        default:
            break
        }
    }

    private func setupBindings() {
        moodListView
            .closeButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.dismissViewController()
        }
    }

    func configure(_ moodManager: MoodManager?, dismissInteractor: DismissViewControllerInteractor) {
        self.moodManager = moodManager
        self.dismissInteractor = dismissInteractor
    }

    private func configureBackButton() {
        let backButton = TappableButton()
        let image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.backgroundBlue
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    private func setupEmptyStateView() {
        let frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height)
        emptyStateView = MoodListEmptyStateView(frame: frame)
        view.addSubview(emptyStateView!)
        emptyStateView?
            .logButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.dismissViewController()
        }
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MoodListViewController: MoodManagerDelegate {

    func didReceiveInitialChanges() {
//        collectionView.reloadData()
    }

    func didReceiveUpdate(deletions: [Int], insertions: [Int], updates: [Int]) {

    }
}

extension MoodListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let monthResultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthResultCollectionViewCell.identifier, for: indexPath) as? MonthResultCollectionViewCell else { fatalError("Could not dequeue MonthResultsCollectionViewCell") }

        monthResultsCell.backgroundColor = .monthResultBackground
        return monthResultsCell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // count of dates sorted by year, sorted by month
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let years = moodManager?.moods.distinct(by: ["year"]) else { return 0 }
        return 5
        //        return years.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: MonthResultHeaderCell.reuseIdentifier,
                                                                             for: indexPath) as? MonthResultHeaderCell else { fatalError("Could not dequeue MonthResultHeaderCell") }
            headerView.configure(year: 6)
            return headerView
        default:
            assertionFailure("Unexpected MoodList collection view error")
        }

        return MonthResultHeaderCell()
    }

}

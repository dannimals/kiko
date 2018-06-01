
import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController {
    private let viewModel: MoodListViewModel
    private var emptyStateView: MoodListEmptyStateView?
//    private let collectionView = UICollectionView()
    private var moodManager: MoodManager?

    required init(viewModel: MoodListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
        setupEmptyStateView()
        view.backgroundColor = .paleBlue
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }

    func configure(_ moodManager: MoodManager?) {
        self.moodManager = moodManager
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

    @objc private func dismissViewController() { navigationController?.popViewController(animated: true) }

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
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // count of dates sorted by year, sorted by month
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let years = moodManager?.moods.distinct(by: ["year"]) else { return 0 }
        return years.count
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

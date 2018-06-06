
import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController {
    private let viewModel: MoodListViewModel
    private var emptyStateView: MoodListEmptyStateView?
    private var collectionView: UICollectionView!
    private var moodManager: MoodManager?

    required init(viewModel: MoodListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        let layout = MoodListCollectionViewLayout()
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout:
            layout)
        setupCollectionView()
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        configureBackButton()
//        setupEmptyStateView()
    }

    private func setupCollectionView() {
        collectionView.register(UINib(nibName: MonthResultCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MonthResultCollectionViewCell.identifier)
        collectionView.register(MonthResultHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: MonthResultHeaderCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .paleBlue
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

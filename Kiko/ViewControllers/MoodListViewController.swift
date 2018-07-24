import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController {
    private let viewModel: MoodListViewModel
    private var emptyStateView: MoodListEmptyStateView?
    private let moodListView: MoodListView = MoodListView.loadFromNib()

    required init(viewModel: MoodListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()

        view = moodListView
        moodListView.collectionView.contentInset.bottom = 100
        moodListView.configure(dataSource: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        moodListView
            .closeButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.dismissViewController()
        }
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
        guard let monthCell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthResultCollectionViewCell.identifier, for: indexPath) as? MonthResultCollectionViewCell
            else { fatalError("Could not dequeue MonthResultsCollectionViewCell") }

        let monthData = viewModel.dataForItemAt(indexPath)
        monthCell.configure(with: monthData)
        return monthCell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section) // count of dates sorted by year, sorted by month
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: MonthResultHeaderCell.reuseIdentifier,
                                                                             for: indexPath) as? MonthResultHeaderCell else { fatalError("Could not dequeue MonthResultHeaderCell") }
            headerView.configure(year: 2018)
            return headerView
        default:
            assertionFailure("Unexpected MoodList collection view error")
        }

        return MonthResultHeaderCell()
    }

}

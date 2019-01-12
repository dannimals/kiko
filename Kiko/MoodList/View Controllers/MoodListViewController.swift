import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController, ViewStylePreparing {
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
        moodListView.configure(dataSource: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setupBindings() {
        moodListView
            .closeButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.dismissViewController()
        }
    }

    func setupViews() {
        setupEmptyStateView()
    }

    func hideEmptyStateView() {
        emptyStateView?.isHidden = true
    }

    private func setupEmptyStateView() {
        let frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height)
        emptyStateView = MoodListEmptyStateView(frame: frame)
        view.addSubview(emptyStateView!)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MoodListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let monthCell = collectionView.dequeueReusableCell(MoodListCollectionViewCell.self, for: indexPath)
        let monthData = viewModel.dataForItemAt(indexPath)
        monthCell.configure(with: monthData)
        return monthCell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = viewModel.numberOfSections()
        if numberOfSections > 0 { hideEmptyStateView() }
        return numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueSupplementaryView(MoodListHeaderCell.self, indexPath: indexPath)
            let year = viewModel.distinctYears[indexPath.section]
            headerView.configure(year: year)
            return headerView
        default: break
        }

        return MoodListHeaderCell()
    }

}

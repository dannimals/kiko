
import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    
    private let viewModel: MoodLogViewModel
    private var moodLogView: MoodLogView!
    private var isUserScrolled = false

    required init(viewModel: MoodLogViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupBindings()
        view.layoutIfNeeded()
        scrollToCurrentWeek()
    }

    private func scrollToCurrentWeek() {
        guard let row = viewModel.index(for: viewModel.displayedStartOfWeekDate) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(viewModel.displayedStartOfWeekDate.month)
        isUserScrolled = true
    }

    private func scrollToNextWeek() {
        viewModel.loadNextWeek()
        if viewModel.hasNewDates {
            moodLogView.insertItemsAt(lastSevenIndexPaths)
        }
        let row = viewModel.index(for: viewModel.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(viewModel.displayedMonth)
    }

    private lazy var firstSevenIndexPaths: [IndexPath] = {
        var indexPaths = [IndexPath]()
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }()

    private lazy var lastSevenIndexPaths: [IndexPath] = {
        var indexPaths = [IndexPath]()
        let itemCount = viewModel.datesIndexesDict.count - 7
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i + itemCount, section: 0))
        }
        return indexPaths
    }()

    private func scrollToLastWeek() {
        viewModel.loadLastWeek()
        if viewModel.hasNewDates {
            moodLogView.insertItemsAt(firstSevenIndexPaths)
        }
        let row = viewModel.index(for: viewModel.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(viewModel.displayedMonth)
    }

    private func setupBindings() {
        moodLogView
            .ringButtonTapped
            .subscribe(self) { _ in
            print("tapped ring button")
        }
        moodLogView
            .wavesButtonTapped
            .subscribe(self) { [weak self] _ in
                let wavesViewController = WavesViewController()
                self?.navigationController?.pushViewController(wavesViewController, animated: true)
        }
        moodLogView
            .logButtonTapped
            .subscribe(self) { _ in
                print("tapped log button")
        }
    }

    private func configureViews() {
        view.backgroundColor = .backgroundYellow
        moodLogView = MoodLogView(frame: view.frame)
        moodLogView.configure(dataSource: self)
        view.addSubview(moodLogView)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    var contentOffSetX: CGFloat = 0

}

extension MoodLogViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.datesIndexesDict.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }

        let day = viewModel.day(for: indexPath)
        dayCell.configure(day: day)
        return dayCell
    }
}

extension MoodLogViewController: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isUserScrolled else { return }
        contentOffSetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isUserScrolled && scrollView.panGestureRecognizer.isEnabled else { return }
        if scrollView.contentOffset.x > contentOffSetX { // + scrollView.bounds.width / 4 {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollToNextWeek()
        } else {
            scrollView.panGestureRecognizer.isEnabled = false
            scrollToLastWeek()
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
}

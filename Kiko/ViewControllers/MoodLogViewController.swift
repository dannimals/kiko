
import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    
    private var contentOffSetX: CGFloat = 0
    private var isUserScrolled = false
    private var moodLogView: MoodLogView!
    private let calendarManager: CalendarManager

    required init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager

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
        guard let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(calendarManager.displayedStartOfWeekDate.month)
        isUserScrolled = true
    }

    private func scrollToNextWeek() {
        calendarManager.loadNextWeek()
        if calendarManager.hasNewDates {
            moodLogView.insertItemsAt(lastSevenIndexPaths)
        }
        let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(calendarManager.displayedMonth)
    }

    private lazy var firstSevenIndexPaths: [IndexPath] = {
        var indexPaths = [IndexPath]()
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }()

    private var lastSevenIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        let itemCount = calendarManager.datesIndexesDict.count - 7
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i + itemCount, section: 0))
        }
        return indexPaths
    }

    private func scrollToLastWeek() {
        calendarManager.loadLastWeek()
        if calendarManager.hasNewDates {
            moodLogView.insertItemsAt(firstSevenIndexPaths)
        }
        let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        moodLogView.updateMonth(calendarManager.displayedMonth)
    }

    private func setupBindings() {
        moodLogView
            .ringButtonTapped
            .subscribe(self) { [unowned self] _ in
                let viewModel = MoodListViewModel()
                let moodListViewController = MoodListViewController(viewModel: viewModel)
                let moodManager = try? MoodManager(delegate: moodListViewController)
                moodListViewController.configure(moodManager)
                let halfModalTransitioningDelegate = HalfModalTransitioningDelegate()
                moodListViewController.modalPresentationStyle = .custom
                moodListViewController.transitioningDelegate = halfModalTransitioningDelegate
                self.present(moodListViewController, animated: true, completion: nil)
        }
        moodLogView
            .wavesButtonTapped
            .subscribe(self) { [unowned self] _ in
                let wavesViewController = WavesViewController()
                self.navigationController?.pushViewController(wavesViewController, animated: true)
        }
        moodLogView
            .logButtonTapped
            .subscribe(self) { _ in
                
        }
        moodLogView
            .rightButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.isUserScrolled = false
                self.scrollToNextWeek()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.isUserScrolled = true
                }
        }
        moodLogView
            .leftButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.isUserScrolled = false
                self.scrollToLastWeek()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.isUserScrolled = true
                }
        }
    }

    private func configureViews() {
        view.backgroundColor = .backgroundYellow
        moodLogView = MoodLogView(frame: view.frame)
        moodLogView.configure(dataSource: self)
        view.addSubview(moodLogView)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension MoodLogViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.datesIndexesDict.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }
        let font: UIFont
        let textColor: UIColor
        let date = calendarManager.dateForIndexPath(indexPath)
        let shouldShowCircle = date ≈≈ Date()
        if shouldShowCircle {
            font = .customFont(ofSize: 16, weight: .heavy)
            textColor = .salmonPink
        } else if date < Date() {
            font = .customFont(ofSize: 14, weight: .medium)
            textColor = .textDarkGrey
        } else {
            font = .customFont(ofSize: 14, weight: .light)
            textColor = .textLightGrey
        }

        dayCell.configure(day: date.day,
                          shouldShowBackgroundCircle: shouldShowCircle,
                          font: font,
                          textColor: textColor)
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

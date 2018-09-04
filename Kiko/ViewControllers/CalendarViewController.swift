import KikoModels
import KikoUIKit

class CalendarViewController: BaseViewController {

    var calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()

    private(set) var isUserScrolled = false
    private(set) var contentOffSetX: CGFloat = 0
    lazy var firstSevenIndexPaths: [IndexPath] = {
        var indexPaths = [IndexPath]()
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }()

    var lastSevenIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        let itemCount = calendarManager.datesIndexesDict.count - 7
        for i in 0..<7 {
            indexPaths.append(IndexPath(row: i + itemCount, section: 0))
        }
        return indexPaths
    }

    private var calendarManager: CalendarManaging!
    private var moodManager: MoodManaging!

    func configure(calendarManager: CalendarManaging, moodManager: MoodManaging) {
        self.calendarManager = calendarManager
        self.moodManager = moodManager
        calendarWeekView.configure(dataSource: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        scrollToCurrentWeek()
        setupBindings()
    }

    private func setupBindings() {
        calendarWeekView
            .rightButtonTapped
            .subscribe(self) { [unowned self] _ in
                self.isUserScrolled = false
                self.scrollToNextWeek()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.isUserScrolled = true
                }
        }
        calendarWeekView
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
        view.addSubview(calendarWeekView)
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        calendarWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarWeekView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarWeekView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

extension CalendarViewController: UICollectionViewDataSource {

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
        var moodColor: UIColor? = nil
        if let mood = moodManager.mood(forDate: date) {
            moodColor = MoodUISetting(rawValue: mood.type)?.accessoryColor
        }

        dayCell.configure(day: date.day,
                          shouldShowBackgroundCircle: shouldShowCircle,
                          font: font,
                          textColor: textColor,
                          moodColor: moodColor)
        return dayCell
    }
}

extension CalendarViewController: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard isUserScrolled else { return }
        contentOffSetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isUserScrolled && scrollView.panGestureRecognizer.isEnabled else { return }
        if scrollView.contentOffset.x > contentOffSetX {
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

    private func scrollToCurrentWeek() {
        guard let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        scrollToIndexPath(indexPath)
        updateMonth(calendarManager.displayedMonth)
        isUserScrolled = true
    }

    private func updateMonth(_ month: Month) {
        calendarWeekView.monthLabel.text = "\(month)".capitalized
    }

    private func insertItemsAt(_ indexPaths: [IndexPath]) {
        calendarWeekView.datesCollectionView.insertItems(at: indexPaths)
    }

    private func scrollToIndexPath(_ indexPath: IndexPath) {
        calendarWeekView.datesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }

    private func scrollToNextWeek() {
        calendarManager.loadNextWeek()
        if calendarManager.hasNewDates {
            insertItemsAt(lastSevenIndexPaths)
        }
        let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        scrollToIndexPath(indexPath)
        updateMonth(calendarManager.displayedMonth)
    }

    private func scrollToLastWeek() {
        calendarManager.loadLastWeek()
        if calendarManager.hasNewDates {
            insertItemsAt(firstSevenIndexPaths)
        }
        let row = calendarManager.index(for: calendarManager.displayedStartOfWeekDate)!
        let indexPath = IndexPath(row: row, section: 0)
        scrollToIndexPath(indexPath)
        updateMonth(calendarManager.displayedMonth)
    }

}

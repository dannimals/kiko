import KikoModels
import KikoUIKit

class CalendarViewController: BaseViewController {

    private let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()
    private var calendarManager: CalendarManaging!
    private var moodManager: MoodManaging!

    func configure(calendarManager: CalendarManaging, moodManager: MoodManaging) {
        self.calendarManager = calendarManager
        self.moodManager = moodManager
        calendarWeekView.configure(dataSource: self, delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupBindings()
        view.layoutIfNeeded()
        reloadDates()
    }

    private func setupBindings() {
        calendarWeekView
            .rightButtonTapped
            .subscribe(self) { [unowned self] _ in self.scrollToNextWeek() }

        calendarWeekView
            .leftButtonTapped
            .subscribe(self) { [unowned self] _ in self.scrollToLastWeek() }
    }

    private func reloadDates() {
        calendarWeekView.userDidScroll = false
        calendarWeekView.datesCollectionView.reloadData()
        calendarWeekView.monthLabel.text = calendarManager.displayedMonth.description
        let width = view.bounds.width
        calendarWeekView.setContentOffset(CGPoint(x: -width, y: 0))
        calendarWeekView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
    }

    private func scrollToNextWeek() {
        calendarManager.loadNextWeek()
        reloadDates()
    }

    private func scrollToLastWeek() {
        calendarManager.loadLastWeek()
        reloadDates()
    }

    private func configureViews() {
        view.addSubview(calendarWeekView)
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        calendarWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarWeekView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarWeekView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

}

extension CalendarViewController: CalendarWeekViewDelegate {

    func calendarDidScrollLeft(_ calendarView: CalendarWeekView) {
        scrollToLastWeek()
    }

    func calendarDidScrollRight(_ calendarView: CalendarWeekView) {
        scrollToNextWeek()
    }

}

extension CalendarViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
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

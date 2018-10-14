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

    func updateColor(_ color: UIColor) {
        calendarWeekView.monthLabel.textColor = color
        calendarWeekView.leftButton.tintColor = color
        calendarWeekView.rightButton.tintColor = color
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

    func reloadDates(animated: Bool = true) {
        calendarWeekView.userDidScroll = false
        let width = view.bounds.width
        calendarWeekView.setContentOffset(CGPoint(x: -width, y: 0))
        calendarWeekView.datesCollectionView.reloadData()
        calendarWeekView.setContentOffset(CGPoint(x: width, y: 0), animated: animated)
        calendarWeekView.monthLabel.text = calendarManager.displayedMonth.description
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
        let date = calendarManager.dateForIndexPath(indexPath)
        var moodColor: UIColor?
        if let mood = moodManager.mood(forDate: date) {
            moodColor = MoodUISetting(rawValue: mood.type)?.accessoryColor
        }
        dayCell.configure(date: date, today: Date(), moodColor: moodColor)
        return dayCell
    }
}

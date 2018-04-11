
import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    
    private let calendarManager: CalendarManager
    private var moodLogView: MoodLogView!
    private var month: Month

    required init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager
        month = calendarManager.currentMonth

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayCurrentWeek()
    }

    private func displayCurrentWeek() {
        moodLogView.updateMonth(month)
        moodLogView.reloadCalendarWeekData()
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
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }
        let font: UIFont
        let textColor: UIColor
        if indexPath.row == 0 {
            let shouldShowCircle = calendarManager.currentDay == calendarManager.beginWeekDate
            font = shouldShowCircle ? .customFont(ofSize: 16, weight: .heavy) : .customFont(ofSize: 14, weight: .medium)
            textColor = shouldShowCircle ? .salmonPink : .textDarkGrey
            dayCell.configure(day: calendarManager.beginWeekDate, shouldShowBackgroundCircle: shouldShowCircle)
        } else {
            let day = calendarManager.beginWeekDate + indexPath.row
            let shouldShowCircle = day == calendarManager.currentDay
            dayCell.configure(day: day, shouldShowBackgroundCircle: shouldShowCircle)

            if shouldShowCircle {
                font = .customFont(ofSize: 16, weight: .heavy)
                textColor = .salmonPink
            } else if day < calendarManager.currentDay {
                font = .customFont(ofSize: 14, weight: .medium)
                textColor = .textDarkGrey
            } else {
                font = .customFont(ofSize: 14, weight: .light)
                textColor = .textLightGrey
            }
        }
        dayCell.configureDayLabel(font: font, textColor: textColor)

        return dayCell
    }
}


import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    private let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()
    private let greetingsLabel = UILabel()
    private let logButton = UIButton()
    private let moodImageView = UIImageView()
    private let ringButton = UIButton()
    private let wavesButton = UIButton()
    private let calendarManager: CalendarManager

    required init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupDataSources()
    }

    private func setupDataSources() {
        calendarWeekView.datesCollectionView.dataSource = self
    }

    private func configureRingButton() {
        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ringButton)
        ringButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 20).isActive = true
        ringButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20).isActive = true
    }

    private func configureWavesButton() {
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wavesButton)
        wavesButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -20).isActive = true
        wavesButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20).isActive = true
    }

    private func configureCalendarView() {
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarWeekView)
        NSLayoutConstraint.activate([
            calendarWeekView.topAnchor.constraint(equalTo: ringButton.bottomAnchor, constant: 24),
            calendarWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarWeekView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureViews() {
        view.backgroundColor = .backgroundYellow
        calendarWeekView.datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        configureRingButton()
        configureWavesButton()
        configureCalendarView()
    }
}

extension MoodLogViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.daysOfYear
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }
        let date = calendarManager.currentDay
        dayCell.configure(date: date)
        return dayCell
    }
}

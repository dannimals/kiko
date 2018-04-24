
import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    
    private let viewModel: MoodLogViewModel
    private var moodLogView: MoodLogView!

    required init(viewModel: MoodLogViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayCurrentWeek()
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

    private func displayCurrentWeek() {
        moodLogView.updateMonth(viewModel.displayedMonth)
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
            let shouldShowCircle = viewModel.currentDay == viewModel.displayedStartOfWeekDay
            font = shouldShowCircle ? .customFont(ofSize: 16, weight: .heavy) : .customFont(ofSize: 14, weight: .medium)
            textColor = shouldShowCircle ? .salmonPink : .textDarkGrey
            dayCell.configure(day: viewModel.displayedStartOfWeekDay, shouldShowBackgroundCircle: shouldShowCircle)
        } else {
            let day = viewModel.displayedStartOfWeekDay + indexPath.row
            let shouldShowCircle = day == viewModel.currentDay
            dayCell.configure(day: day, shouldShowBackgroundCircle: shouldShowCircle)

            if shouldShowCircle {
                font = .customFont(ofSize: 16, weight: .heavy)
                textColor = .salmonPink
            } else if day < viewModel.currentDay {
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

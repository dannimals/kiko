
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
        view.layoutIfNeeded()
        scrollToCurrentWeek()
    }

    private func scrollToCurrentWeek() {
        let row = viewModel.index(of: viewModel.displayedStartOfWeekDate)
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
    }

    private func scrollToNextWeek() {
        let currentDisplayedStartOfWeekDate = viewModel.displayedStartOfWeekDate
        viewModel.displayedStartOfWeekDate = currentDisplayedStartOfWeekDate.nextStartOfWeek
        let row = viewModel.index(of: viewModel.displayedStartOfWeekDate)
        let indexPath = IndexPath(row: row, section: 0)
        moodLogView.scrollToIndexPath(indexPath)
        viewModel.updateWeeksForDate(viewModel.displayedStartOfWeekDate)
//        moodLogView.reloadCalendarWeekData()
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

    var contextOffSetX: CGFloat = 0

}

extension MoodLogViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayDates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }

        let day = viewModel.dayForIndexPath(indexPath)
        dayCell.configure(day: day)
        return dayCell
    }
}

extension MoodLogViewController: UICollectionViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetX = scrollView.contentOffset.x
            scrollToNextWeek()

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        if offSetX > contextOffSetX {
            scrollToNextWeek()
        }
    }
}

import KikoUIKit

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: WeekCalendarCollectionView!

    var userDidScroll = false
    let leftButtonTapped = Channel<UIControlEvents>()
    let rightButtonTapped = Channel<UIControlEvents>()

    @objc private func notifyLeftButtonTappedEvent() { leftButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyRightButtonTappedEvent() { rightButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    func configure(dataSource: UICollectionViewDataSource & InfiniteScrollableDelegate) {
        datesCollectionView.dataSource = dataSource
        datesCollectionView.delegate = self
        datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        datesCollectionView.configure(delegate: dataSource)

        setupEvents()
    }

    private func setupEvents() {
        leftButton.addTarget(self, action: #selector(notifyLeftButtonTappedEvent), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(notifyRightButtonTappedEvent), for: .touchUpInside)
    }

    func set(contentOffset: CGPoint) {
        datesCollectionView.contentOffset = contentOffset
    }

    func updateViewColor(_ color: UIColor = .cornflowerYellow) {
        UIView.animate(withDuration: 0.4) {
            self.monthLabel.textColor = color
            self.leftButton.tintColor = color
            self.rightButton.tintColor = color
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        updateViewColor()
        datesCollectionView.backgroundColor = backgroundColor
    }
}

extension CalendarWeekView: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userDidScroll else { return }
        userDidScroll = false
        datesCollectionView.recenterIfNecessary()
    }

}

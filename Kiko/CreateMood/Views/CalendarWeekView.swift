import KikoUIKit

enum ScrollDirection: Int {
    case left = -1
    case right = 1
}

protocol CalendarWeekViewDelegate: class {
    func calendarDidScrollLeft(_ calendarView: CalendarWeekView)
    func calendarDidScrollRight(_ calendarView: CalendarWeekView)
}

class CalendarWeekView: UIView, ViewStylePreparing {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: UICollectionView!

    var userDidScroll = false
    let leftButtonTapped = Channel<UIControlEvents>()
    let rightButtonTapped = Channel<UIControlEvents>()

    private var contentOffsetX: CGFloat = 0
    private var beginOffsetX: CGFloat = 0

    private weak var calendarDelegate: CalendarWeekViewDelegate?

    @objc private func notifyLeftButtonTappedEvent() { leftButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyRightButtonTappedEvent() { rightButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    func configure(dataSource: UICollectionViewDataSource,
                   delegate: CalendarWeekViewDelegate) {
        datesCollectionView.dataSource = dataSource
        calendarDelegate = delegate
    }

    func setupViews() {
        leftButton.addTarget(self, action: #selector(notifyLeftButtonTappedEvent), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(notifyRightButtonTappedEvent), for: .touchUpInside)
        datesCollectionView.registerCellClass(CalendarDayCollectionViewCell.self)
        datesCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        datesCollectionView.delegate = self
        datesCollectionView.isPagingEnabled = true
    }

    private func updateViewColor(_ color: UIColor = .yellow03) {
        UIView.animate(withDuration: 0.4) {
            self.monthLabel.textColor = color
            self.leftButton.tintColor = color
            self.rightButton.tintColor = color
        }
    }

    func setupColors() {
        updateViewColor()
        datesCollectionView.backgroundColor = backgroundColor
    }

    func setupFonts() {
        monthLabel.font = UIFont.customFont(ofSize: 22, weight: .semibold)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }
}

extension CalendarWeekView: UICollectionViewDelegate {

    var screenWidth: CGFloat { return bounds.width }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userDidScroll = true
        beginOffsetX = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userDidScroll else { return }

        if scrollView.contentOffset.x - beginOffsetX >= screenWidth {
            calendarDelegate?.calendarDidScrollRight(self)
            userDidScroll = false
        } else if beginOffsetX - scrollView.contentOffset.x >= screenWidth {
            calendarDelegate?.calendarDidScrollLeft(self)
            userDidScroll = false
        }
    }

    func setContentOffset(_ offset: CGPoint, animated: Bool = false) {
        datesCollectionView.setContentOffset(offset, animated: animated)
    }

}

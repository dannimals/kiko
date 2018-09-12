import KikoUIKit

enum ScrollDirection: Int {
    case left = -1
    case right = 1
}

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: WeekCalendarCollectionView!

    var scrollDirection: ScrollDirection = .right
    var userDidScroll = false
    let leftButtonTapped = Channel<UIControlEvents>()
    let rightButtonTapped = Channel<UIControlEvents>()

    private var contentOffsetX: CGFloat = 0
    private var beginOffsetX: CGFloat = 0

    @objc private func notifyLeftButtonTappedEvent() { leftButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyRightButtonTappedEvent() { rightButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    func configure(dataSource: UICollectionViewDataSource & InfiniteScrollableDelegate) {
        datesCollectionView.dataSource = dataSource
        datesCollectionView.delegate = self
        datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        datesCollectionView.configure(delegate: dataSource)
        datesCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
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

    var screenWidth: CGFloat {
        return bounds.width
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userDidScroll = true
        beginOffsetX =  CGFloat(Int(scrollView.contentOffset.x / screenWidth)) * screenWidth
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard userDidScroll && scrollView.panGestureRecognizer.isEnabled else { return }
        contentOffsetX = scrollView.contentOffset.x
        scrollDirection = contentOffsetX > beginOffsetX ? .right : .left
        let distanceScrolled = fabs(contentOffsetX) - fabs(beginOffsetX)
        let scrollThreshold = 0.3 * screenWidth

        if fabs(distanceScrolled) >= scrollThreshold {
            let count = Int(beginOffsetX / screenWidth) + scrollDirection.rawValue
            let maxScrollOffset =  screenWidth * CGFloat(count)
            capScrollView(scrollView, withOffset: maxScrollOffset, direction: scrollDirection)
        }

        //        datesCollectionView.recenterIfNecessary()
    }

    private func capScrollView(_ scrollView: UIScrollView, withOffset offset: CGFloat, direction: ScrollDirection) {
        userDidScroll = false
        let cappedOffsetX = cappedCurrentOffset(offset, direction: direction)
        let contentOffset = CGPoint(x: cappedOffsetX, y: scrollView.contentOffset.y)
        scrollView.setContentOffset(contentOffset, animated: true)
        scrollView.panGestureRecognizer.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = true
    }

    private func cappedCurrentOffset(_ currentOffset: CGFloat, direction: ScrollDirection) -> CGFloat {
        let roundWidths = round(currentOffset / screenWidth)
        return roundWidths * screenWidth
    }

}

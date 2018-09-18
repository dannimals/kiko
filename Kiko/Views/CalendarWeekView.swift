import KikoUIKit

enum ScrollDirection: Int {
    case left = -1
    case right = 1
}

protocol CalendarWeekViewDelegate: class {
    func calendarDidScrollLeft(_ calendarView: CalendarWeekView)
    func calendarDidScrollRight(_ calendarView: CalendarWeekView)
}

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: UICollectionView!

    var scrollDirection: ScrollDirection = .right
    var userDidScroll = false
    let leftButtonTapped = Channel<UIControlEvents>()
    let rightButtonTapped = Channel<UIControlEvents>()

    private var contentOffsetX: CGFloat = 0
    private var beginOffsetX: CGFloat = 0

    private weak var calendarDelegate: CalendarWeekViewDelegate?

    @objc private func notifyLeftButtonTappedEvent() { leftButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyRightButtonTappedEvent() { rightButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    func configure(dataSource: UICollectionViewDataSource, delegate: CalendarWeekViewDelegate) {
        datesCollectionView.dataSource = dataSource
        datesCollectionView.delegate = self
        datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        datesCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        calendarDelegate = delegate
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
            let maxScrollOffset = screenWidth * CGFloat(count)
            capScrollView(scrollView, withOffset: maxScrollOffset, direction: scrollDirection)
            let delayTime = DispatchTime.now() + 0.3
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                switch self.scrollDirection {
                case .left:
                    self.calendarDelegate?.calendarDidScrollLeft(self)
                case .right:
                    self.calendarDelegate?.calendarDidScrollRight(self)
                }
                let offset = CGPoint(x: self.bounds.width, y: 0)
                self.datesCollectionView.setContentOffset(offset, animated: false)
            }
        }
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        contentOffsetX = scrollView.contentOffset.x
//        scrollDirection = contentOffsetX > beginOffsetX ? .right : .left
//        let distanceScrolled = fabs(contentOffsetX) - fabs(beginOffsetX)
//        let scrollThreshold = 0.3 * screenWidth
//
//        if fabs(distanceScrolled) >= scrollThreshold {
//            let count = Int(beginOffsetX / screenWidth) + scrollDirection.rawValue
//            let maxScrollOffset = screenWidth * CGFloat(count)
//            capScrollView(scrollView, withOffset: maxScrollOffset, direction: scrollDirection)
//            switch scrollDirection {
//            case .left:
//                calendarDelegate?.calendarDidScrollLeft(self)
//            case .right:
//                calendarDelegate?.calendarDidScrollRight(self)
//            }
//        }
//    }


    private func capScrollView(_ scrollView: UIScrollView, withOffset offset: CGFloat, direction: ScrollDirection) {
        userDidScroll = false
        let offset = cappedCurrentOffset(offset, direction: direction)
        let contentOffset = CGPoint(x: offset, y: scrollView.contentOffset.y)
        scrollView.setContentOffset(contentOffset, animated: true)
        scrollView.panGestureRecognizer.isEnabled = false
        scrollView.panGestureRecognizer.isEnabled = true
    }

    private func cappedCurrentOffset(_ currentOffset: CGFloat, direction: ScrollDirection) -> CGFloat {
        let roundWidths = round(currentOffset / screenWidth)
        let offset = roundWidths * screenWidth
        return offset
    }

}

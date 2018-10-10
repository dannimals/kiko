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
        let scrollDirection: ScrollDirection = contentOffsetX > beginOffsetX ? .right : .left
        let distanceScrolled = fabs(contentOffsetX) - fabs(beginOffsetX)
        let scrollThreshold = 0.3 * screenWidth

        if fabs(distanceScrolled) >= scrollThreshold {
            let count = Int(beginOffsetX / screenWidth) + scrollDirection.rawValue
            let maxScrollOffset = screenWidth * CGFloat(count)
            capScrollView(scrollView, withOffset: maxScrollOffset, direction: scrollDirection)
            let delayTime = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                switch scrollDirection {
                case .left:
                    self.calendarDelegate?.calendarDidScrollLeft(self)
                case .right:
                    self.calendarDelegate?.calendarDidScrollRight(self)
                }
                let offset = CGPoint(x: self.bounds.width, y: 0)
                self.setContentOffset(offset)
            }
        }
    }

    func setContentOffset(_ offset: CGPoint, animated: Bool = false) {
        self.datesCollectionView.setContentOffset(offset, animated: animated)
    }

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let delayTime = DispatchTime.now() + 0.4
//        DispatchQueue.main.asyncAfter(deadline: delayTime) {
//            self.contentOffsetX = scrollView.contentOffset.x
//
//            guard Int(self.contentOffsetX / self.bounds.width) != 0 else { return }
//            self.userDidScroll = false
//            let scrollDirection: ScrollDirection = self.contentOffsetX > self.beginOffsetX ? .right : .left
//            let distanceScrolled = fabs(self.contentOffsetX) - fabs(self.beginOffsetX)
//            let scrollThreshold = 0.3 * self.screenWidth
//
//            if fabs(distanceScrolled) >= scrollThreshold {
//                let count = Int(self.beginOffsetX / self.screenWidth) + scrollDirection.rawValue
//                let maxScrollOffset = self.screenWidth * CGFloat(count)
//                self.capScrollView(scrollView, withOffset: maxScrollOffset, direction: scrollDirection)
//                let delayTime = DispatchTime.now() + 0.3
//                DispatchQueue.main.asyncAfter(deadline: delayTime) {
//                    switch scrollDirection {
//                    case .left:
//                        self.calendarDelegate?.calendarDidScrollLeft(self)
//                    case .right:
//                        self.calendarDelegate?.calendarDidScrollRight(self)
//                    }
//                    let offset = CGPoint(x: self.bounds.width, y: 0)
//                    self.datesCollectionView.setContentOffset(offset, animated: false)
//                }
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

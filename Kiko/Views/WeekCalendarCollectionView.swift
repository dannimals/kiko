import KikoUIKit

protocol InfiniteScrollableDelegate: class {
    func scrollViewDidScrollToLeft(_ scrollView: UIScrollView)
    func scrollViewDidScrollToRight(_ scrollView: UIScrollView)
}

class WeekCalendarCollectionView: InfiniteScrollCollectionView {

    private weak var scrollableDelegate: InfiniteScrollableDelegate?

    func configure(delegate: InfiniteScrollableDelegate) {
        self.scrollableDelegate = delegate
    }
    override func didScrollToLeft() {
        scrollableDelegate?.scrollViewDidScrollToLeft(self)
    }

    override func didScrollToRight() {
        scrollableDelegate?.scrollViewDidScrollToRight(self)
    }

    override func updateVisibleContent(offset: CGFloat) {
        for cell in visibleCells {
            var center = cell.center
            center.x += offset
            cell.center = center
        }
    }
}

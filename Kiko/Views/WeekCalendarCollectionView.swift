import KikoUIKit

protocol InfiniteScrollableDelegate: class {
    func scrollViewDidScrollToLeft(_ scrollView: UICollectionView)
    func scrollViewDidScrollToRight(_ scrollView: UICollectionView)
}

class WeekCalendarCollectionView: UICollectionView {

    private weak var scrollableDelegate: InfiniteScrollableDelegate?

    func configure(delegate: InfiniteScrollableDelegate) {
        self.scrollableDelegate = delegate
    }

    private func updateVisibleContent(offset: CGFloat) {
        for cell in visibleCells {
            var center = cell.center
            center.x += offset
            cell.center = center
        }
    }

    private func setupCollectionView() {
        contentSize = CGSize(width: 3 * bounds.width, height: 500)
    }

    func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width) / 2

        let currentCenterOffset = currentOffset.x - centerOffsetX
        let distanceFromCenter = fabs(currentCenterOffset)

        if fabs(currentCenterOffset) >= bounds.width - visibleCells.first!.bounds.width {
            panGestureRecognizer.isEnabled = false
            contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
            updateVisibleContent(offset: centerOffsetX - currentOffset.x)
            if currentCenterOffset < 0 {
                scrollableDelegate?.scrollViewDidScrollToRight(self)
            } else {
                scrollableDelegate?.scrollViewDidScrollToLeft(self)
            }
        }
    }

}

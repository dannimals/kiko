import KikoUIKit

class InfiniteScrollCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        contentSize = CGSize(width: 1000, height: 500)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    func updateVisibleContent(offset: CGFloat) {}
    func didScrollToLeft() {}
    func didScrollToRight() {}

    private func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width) / 2

        let currentCenterOffset = currentOffset.x - centerOffsetX
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)

        if distanceFromCenter > bounds.width {
            contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)
            updateVisibleContent(offset: centerOffsetX - currentOffset.x)
            currentCenterOffset > 0 ? didScrollToRight() : didScrollToLeft()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        recenterIfNecessary()
    }
}

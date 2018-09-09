import KikoUIKit

class InfiniteScrollCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        contentSize = CGSize(width: 3 * bounds.width, height: 500)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    func didScrollToLeft() {}
    func didScrollToRight() {}
    func updateVisibleContent(offset: CGFloat) {}

    private func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width) / 2

        let currentCenterOffset = currentOffset.x - centerOffsetX
        let distanceFromCenter = fabs(currentOffset.x - centerOffsetX)

        if distanceFromCenter > bounds.width / 2 {
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

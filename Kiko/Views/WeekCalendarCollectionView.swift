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

    private func setupCollectionView() {
        contentSize = CGSize(width: 3 * bounds.width, height: 500)
    }

}

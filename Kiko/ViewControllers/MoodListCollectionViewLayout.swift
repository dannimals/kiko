import KikoUIKit

class MoodListCollectionViewLayout: UICollectionViewLayout {

    private var contentSize = CGSize.zero
    private var horizontalPadding: CGFloat = 25.0
    private var verticalPadding: CGFloat = 25.0
    private var verticalInset: CGFloat =  18.0
    private var itemWidth: CGFloat = 0.0
    private var itemHeight: CGFloat = 150.0
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private let numberOfColumns = 1

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        layoutAttributes.removeAll()
        let numberOfSections = collectionView.numberOfSections
        var yOffset = verticalPadding
        var xOffset = horizontalPadding
        let totalGutterWidth = 2 * horizontalPadding
        itemWidth = collectionView.bounds.width - totalGutterWidth

        for section in 0..<numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = CGSize(width: itemWidth, height: itemHeight)
                var increaseRow = false

                if collectionView.frame.size.width - xOffset - horizontalPadding < itemWidth {
                    increaseRow = true
                }

                if increaseRow {
                    yOffset += verticalInset + itemSize.height
                    xOffset = horizontalPadding
                }

                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                layoutAttributes.append(attributes)

                xOffset += itemSize.width
            }
        }

        contentSize = CGSize(width: collectionView.frame.size.width, height: yOffset + itemWidth)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.filter { $0.indexPath == indexPath }.first
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }

}

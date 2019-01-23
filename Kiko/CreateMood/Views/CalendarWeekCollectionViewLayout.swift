import KikoUIKit

class CalendarWeekCollectionViewLayout: UICollectionViewLayout {

    private var contentSize = CGSize.zero
    private var numberOfColumns = 7
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var itemSpacing: CGFloat = 8
    private var gutterSpacing: CGFloat = 4

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        super.prepare()

        layoutAttributes.removeAll()
        guard let collectionView = collectionView else { return }

        var xOffset: CGFloat = gutterSpacing
        let itemWidth = (collectionView.bounds.width - 2 * gutterSpacing - 6 * itemSpacing) / CGFloat(numberOfColumns)
        let itemHeight = collectionView.bounds.height
        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let itemSize = CGSize(width: itemWidth, height: itemHeight)
                attributes.frame = CGRect(x: xOffset, y: 0, width: itemWidth, height: itemHeight)
                layoutAttributes.append(attributes)
                xOffset += itemSize.width + itemSpacing
            }
        }

        contentSize = CGSize(width: xOffset, height: collectionView.bounds.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in layoutAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
}

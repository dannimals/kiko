import KikoUIKit

class MoodListCollectionViewLayout: UICollectionViewLayout {

    private var contentSize = CGSize.zero
    private var horizontalPadding: CGFloat = 25.0
    private var verticalPadding: CGFloat = 25.0
    private var verticalItemInset: CGFloat =  18.0
    private var itemHeight: CGFloat = 150.0
    private var itemLayoutAttributes = [UICollectionViewLayoutAttributes]()
    private var sectionHeaderLayoutAttributes = [UICollectionViewLayoutAttributes]()
    private let sectionHeaderHeight: CGFloat = 60.0

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        itemLayoutAttributes.removeAll()
        sectionHeaderLayoutAttributes.removeAll()
        let numberOfSections = collectionView.numberOfSections
        var yOffset = verticalPadding
        var xOffset = horizontalPadding
        let totalGutterWidth = 2 * horizontalPadding
        let itemWidth = collectionView.bounds.width - totalGutterWidth

        for section in 0..<numberOfSections {
            let sectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
            let sectionHeaderFrame = CGRect(x: 0, y: yOffset, width: collectionView.bounds.width, height: sectionHeaderHeight)
            sectionAttributes.frame = sectionHeaderFrame
            sectionHeaderLayoutAttributes.append(sectionAttributes)
            yOffset += sectionHeaderHeight + verticalItemInset

            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                if collectionView.frame.size.width - xOffset - horizontalPadding < itemWidth {
                    yOffset += verticalItemInset
                    xOffset = horizontalPadding
                }

                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemLayoutAttributes.append(attributes)

                xOffset += itemWidth
                yOffset += itemHeight + verticalItemInset
            }
        }

        contentSize = CGSize(width: collectionView.frame.size.width, height: yOffset)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributes.filter { $0.indexPath == indexPath }.first
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            return sectionHeaderLayoutAttributes.filter { $0.indexPath == indexPath }.first
        default:
            return nil
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = sectionHeaderLayoutAttributes + itemLayoutAttributes
        return attributes.filter { rect.intersects($0.frame) }
    }

}

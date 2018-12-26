
import UIKit

public extension UICollectionView {

    public func registerViewClass<T: UICollectionReusableView>(_ view: T.Type, forSupplementaryViewOfKind kind: String = UICollectionElementKindSectionHeader) {
        register(view, forSupplementaryViewOfKind: kind, withReuseIdentifier: view.identifier)
    }

    public func registerNibCell<T: UICollectionViewCell>(_: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }

    public func registerCellClass<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

}

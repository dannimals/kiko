public extension UICollectionView {

    public func registerCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
}

protocol NibIdentifiable where Self: UIViewController {
    static var identifier: String { get }
}

extension UIViewController: NibIdentifiable {
    public static var identifier: String { return String(describing: self) }
}

extension UIViewController {
    public static func loadFromNib<T: UIViewController>() -> T {
        guard let viewController = Bundle.main.loadNibNamed(T.identifier, owner: self, options: nil)?.first as? T else { fatalError("Error loading nib with name \(identifier)") }

        return viewController
    }
}

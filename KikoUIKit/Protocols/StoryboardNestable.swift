
import UIKit

public protocol NibRepresentable: class {}

public extension UINib {

    public typealias Name = String

}

public extension NibRepresentable {

    public static var nibName: UINib.Name { return String(describing: self) }

    public static func instantiateFromNib() -> Self {
        return instantiateFromNib(withName: nibName)
    }

    public static func instantiateFromNib(withName nibName: String) -> Self {
        return Bundle(for: self).loadNibNamed(nibName, owner: self, options: nil)?.first as! Self
    }

}

public protocol StoryboardNestable: NibRepresentable {

    var contentView: UIView! { get }

}

public extension StoryboardNestable where Self: UIView {

    public func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed(Self.nibName, owner: self, options: [:])
        contentView.stretchToFill()
        let contentConstraints = contentView.constraints
        contentView.subviews.forEach({ addSubview($0) })

        for constraint in contentConstraints {
            let firstItem = (constraint.firstItem as? UIView == contentView) ? self : constraint.firstItem
            let secondItem = (constraint.secondItem as? UIView == contentView) ? self : constraint.secondItem
            let newConstraint = NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
            newConstraint.identifier = constraint.identifier
            addConstraint(newConstraint)
        }
    }
}

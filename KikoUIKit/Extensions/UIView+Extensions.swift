public extension UIView {

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    static func loadFromNib<T: Identifiable>() -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? T else { fatalError("Error loading nib with name \(identifier)") }
        return view
    }

    public func stretchToFill(parentView: UIView) {
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.safeTopAnchor),
            leftAnchor.constraint(equalTo: parentView.leftAnchor),
            rightAnchor.constraint(equalTo: parentView.rightAnchor),
            bottomAnchor.constraint(equalTo: parentView.safeBottomAnchor)
        ])
    }

    public func stretchToFill() {
        guard let parentView = superview else { return }
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.safeTopAnchor),
            leftAnchor.constraint(equalTo: parentView.leftAnchor),
            rightAnchor.constraint(equalTo: parentView.rightAnchor),
            bottomAnchor.constraint(equalTo: parentView.safeBottomAnchor)
            ])
    }

    public func addShadow(shadowRadius: CGFloat = 3, shadowColor: CGColor = UIColor.black.cgColor, shadowOffset: CGSize = CGSize(width: 0, height: 8), shadowOpacity: CGFloat = 0.3) {
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
}

extension UIView: Identifiable {
    public static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}

extension UIView {

    public var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    public var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }

    public var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }

    public var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}

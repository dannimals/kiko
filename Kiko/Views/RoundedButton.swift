import KikoUIKit

class RoundedButton: UIButton {

    @IBInspectable var highlightedBackgroundColor: UIColor? {
        didSet {
            backgroundColor = isHighlighted ? highlightedBackgroundColor : backgroundColor
        }
    }

    @IBInspectable var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    private func setup() {
        layer.cornerRadius = bounds.height / 2
        titleLabel?.font = UIFont.customFont(ofSize: 17, weight: .heavy)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}


import KikoUIKit

class ButtonsDrawerView: UIView {

    private var buttons: [UIButton] = []
    private var inset: CGFloat = 0
    var initialOffset: CGFloat = 0
    private var isOpen = false
    private lazy var pathAnimation: CABasicAnimation = {
        let pathAnimation = CABasicAnimation(keyPath: "position.y")
        pathAnimation.duration = 0.2
        return pathAnimation
    }()
    private lazy var alphaAnimation: CABasicAnimation = {
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.duration = 0.2
        return alphaAnimation
    }()

    func configure(buttons: [UIButton], initialOffset: CGFloat = 0, inset: CGFloat = 16) {
        self.buttons = buttons
        self.inset = inset
        self.initialOffset = initialOffset
        layoutButtons()
    }

    override var intrinsicContentSize: CGSize {
        let maxButtonWidth = buttons.max(by: { $0.bounds.width > $1.bounds.width })?.bounds.width ?? 0
        let totalHeight = buttons.map { $0.bounds.height }.reduce(0, +) + CGFloat(buttons.count - 1) * inset + initialOffset
        return CGSize(width: maxButtonWidth, height: totalHeight)
    }

    private func layoutButtons() {
        for button in buttons {
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        }
        buttons.forEach { $0.alpha = 0 }
    }

    func toggle() {
        isOpen ? close() : open()
    }

    private func close() {
        isOpen = false
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        for i in 0..<buttons.count {
            let button = buttons[i]
            let toValue = bounds.height - button.bounds.height / 2
            pathAnimation.fromValue = button.layer.position.y
            pathAnimation.toValue = toValue
            button.layer.add(pathAnimation, forKey: nil)
            button.layer.position.y = toValue
            button.layer.add(alphaAnimation, forKey: nil)
            button.alpha = 0
        }
    }

    private func open() {
        isOpen = true
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 1
        for i in 0..<buttons.count {
            var buttonOffset: CGFloat = 0
            for j in 0..<i {
                buttonOffset += buttons[j].bounds.height
            }
            let button = buttons[i]
            let toValue = button.bounds.height / 2 + buttonOffset + CGFloat(min(0, i - 1)) * inset
            pathAnimation.fromValue = button.layer.position.y
            pathAnimation.toValue = toValue
            button.layer.add(pathAnimation, forKey: nil)
            button.layer.position.y = toValue
            button.layer.add(alphaAnimation, forKey: nil)
            button.alpha = 1
        }
    }
}

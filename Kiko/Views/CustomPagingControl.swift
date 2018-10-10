
import KikoUIKit

class CustomPagingControl: UIView {

    private let defaultSelectedColor = UIColor.cornflowerYellow
    private let circleStackView = UIStackView()
    private(set) var selectedIndex: Int = 0

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func update(selectedIndex: Int, color: UIColor) {
        self.selectedIndex = selectedIndex
        circleStackView.arrangedSubviews.forEach { $0.backgroundColor = color.faded }
        circleStackView.arrangedSubviews[selectedIndex].backgroundColor = color
    }

    private func addCircleView() -> UIView {
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.cornerRadius = bounds.height / 2
        circleView.widthAnchor.constraint(equalToConstant: bounds.height).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        return circleView
    }

    private func setup() {
        for _ in 0..<4 { circleStackView.addArrangedSubview(addCircleView()) }
        circleStackView.axis = .horizontal
        circleStackView.distribution = .equalCentering
        circleStackView.spacing = 7
        circleStackView.arrangedSubviews.forEach { $0.backgroundColor = defaultSelectedColor.faded }
        circleStackView.arrangedSubviews.first?.backgroundColor = defaultSelectedColor
        circleStackView.stretchToFill(parentView: self)
    }

}

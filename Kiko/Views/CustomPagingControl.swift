
import KikoUIKit

class CustomPagingControl: UIView {

    private let defaultColor = UIColor.cornflowerYellow
    private let circleStackView = UIStackView()

    func update(selectedIndex: Int, color: UIColor) {
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

    func setup() {
        for _ in 0..<4 { circleStackView.addArrangedSubview(addCircleView()) }
        circleStackView.axis = .horizontal
        circleStackView.distribution = .equalCentering
        circleStackView.spacing = 7
        circleStackView.arrangedSubviews.forEach { $0.backgroundColor = defaultColor.faded }
        circleStackView.arrangedSubviews.first?.backgroundColor = defaultColor
        circleStackView.stretchToFill(parentView: self)
    }

}

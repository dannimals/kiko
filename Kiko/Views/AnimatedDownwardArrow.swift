
import KikoUIKit

class AnimatedDownwardArrow: UIView {

    private let strokeColor = UIColor.white
    private let lineWidth: CGFloat = 4
    private let path = UIBezierPath()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundColor = .clear
    }

    var centerYOffset: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        drawArrow(centerYOffset: centerYOffset)
    }

    func drawArrow(centerYOffset: CGFloat = 0) {
        path.removeAllPoints()
        path.move(to: CGPoint(x: 4, y: 4))
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height - centerYOffset - lineWidth))
        path.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth))
        path.lineWidth = lineWidth
        strokeColor.set()
        path.lineCapStyle = .round
        path.stroke()
    }
}

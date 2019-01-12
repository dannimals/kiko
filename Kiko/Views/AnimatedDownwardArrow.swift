
import KikoUIKit

class AnimatedDownwardArrow: UIView {

    private let strokeColor = UIColor.white
    private let lineWidth: CGFloat = 4
    private let path = UIBezierPath()
    private let startPoint = CGPoint(x: 4, y: 4)

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

        update(centerYOffset: centerYOffset)
    }

    private func update(centerYOffset: CGFloat = 0) {
        let minMidpointOffsetY = bounds.height / 2
        guard centerYOffset >= 0 else {
            alpha = 1
            drawArrow(midPoint: bounds.height - lineWidth)
            return
        }
        let midPointOffsetY = bounds.height - centerYOffset - lineWidth
        guard midPointOffsetY > minMidpointOffsetY else {
            drawArrow(midPoint: midPointOffsetY)
            hide()
            return
        }
        show()
        drawArrow(midPoint: midPointOffsetY)
    }

    private func drawArrow(midPoint: CGFloat) {
        path.removeAllPoints()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: bounds.width / 2, y: midPoint))
        path.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth))
        path.lineWidth = lineWidth
        strokeColor.set()
        path.lineCapStyle = .round
        path.stroke()
    }

    private func drawArrorWithoutOffset() {
        path.removeAllPoints()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.height - lineWidth))
        path.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth))
        path.lineWidth = lineWidth
        strokeColor.set()
        path.lineCapStyle = .round
        path.stroke()
    }

    private func hide() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 0
        }
    }

    private func show() {
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
}

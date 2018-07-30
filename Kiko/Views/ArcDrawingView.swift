import KikoUIKit
import KikoModels

class ArcDrawingView: UIView {
    private var monthData: MonthData?

    func update(monthData: MonthData) {
        self.monthData = monthData
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let monthData = monthData else { return }

        let radius = rect.width / 2 - 5
        let arcCenter = CGPoint(x: rect.width / 2, y: rect.width / 2)
        let strokeWidth: CGFloat = 10.0
        var currentEndAngle: CGFloat = 0

        for i in 0..<4 {
            let oldAngle = currentEndAngle
            let moodType = unwrapOrElse(MoodType(rawValue: i), fallback: MoodType.chick)
            let monthPercentage = CGFloat(monthData.countOf(moodType: moodType)) / CGFloat(monthData.totalDays)
            let strokeColor = unwrapOrElse(MoodUISetting(rawValue: i)?.accessoryColor, fallback: UIColor.backgroundYellow)
            currentEndAngle += 2 * CGFloat.pi * monthPercentage
            drawPath(arcCenter: arcCenter, radius: radius, startAngle: oldAngle, endAngle: currentEndAngle, strokeWidth: strokeWidth, strokeColor: strokeColor)
        }
    }

    func drawPath(arcCenter: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, strokeWidth: CGFloat, strokeColor: UIColor) {
        let strokePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        strokePath.lineWidth = strokeWidth
        strokeColor.setStroke()
        strokePath.stroke()
    }
}

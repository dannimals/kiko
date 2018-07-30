import KikoModels
import KikoUIKit

class LineDrawingView: UIView {
    var totalDays: Int?
    var moodCount: MonthData.MoodCount?

    func update(monthData: MonthData, day: Day) {
        self.totalDays = monthData.countOf(day: day)
        self.moodCount = monthData.moodCountOf(day: day)
        backgroundColor = .clear
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let moodCount = moodCount else { return }

        let strokeHeight: CGFloat = bounds.height
        var currentPercentage: CGFloat = 0
        var x: CGFloat = 0

        for i in 0..<4 {
            let moodType = unwrapOrElse(MoodType(rawValue: i), fallback: MoodType.chick)
            let countOfDaysWithMood = unwrapOrEmpty(moodCount[moodType])
            let dayPercentage = CGFloat(countOfDaysWithMood) / CGFloat(unwrapOrElse(totalDays, fallback: 1))
            let strokeColor = unwrapOrElse(MoodUISetting(rawValue: i)?.backgroundColor, fallback: UIColor.backgroundYellow)
            let shouldCap = i == 0 || i == 3
            currentPercentage += dayPercentage
            x += currentPercentage * bounds.width
            drawPath(x: x, width: currentPercentage * bounds.width, height: strokeHeight, strokeColor: strokeColor, shouldCap: shouldCap)
        }
    }

    func drawPath(x: CGFloat, width: CGFloat, height: CGFloat, strokeColor: UIColor, shouldCap: Bool) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: bounds.origin.y - width / 2))
        path.addLine(to: CGPoint(x: x + width, y: bounds.origin.y - width / 2))
        path.close()
        path.lineWidth = bounds.width
        if shouldCap {
//            path.lineCapStyle = .round
        }
        strokeColor.set()
        path.stroke()
        path.fill()
    }
}

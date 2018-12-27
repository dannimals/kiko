import KikoModels
import KikoUIKit

class LineDrawingView: UIView {

    private var totalDays: Int?
    private var moodCount: MonthData.MoodCount?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .defaultLineColor
    }

    func update(monthData: MonthData, day: Day) {
        self.totalDays = monthData.countOf(day: day)
        self.moodCount = monthData.moodCountOf(day: day)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let moodCount = moodCount, moodCount.values.contains(where: { $0 > 0 }), let totalDays = totalDays else { return }

        let strokeHeight: CGFloat = bounds.height
        var x: CGFloat = 0

        for i in 0..<4 {
            let moodType = unwrapOrElse(MoodType(rawValue: i), fallback: MoodType.chick)
            let countOfDaysWithMood = unwrapOrEmpty(moodCount[moodType])
            let dayPercentage = CGFloat(countOfDaysWithMood) / CGFloat(totalDays)
            guard dayPercentage > 0 else { continue }
            let strokeColor = MoodPageDisplay(type: moodType).accessoryColor
            drawPath(x: x, width: dayPercentage * bounds.width, height: strokeHeight, strokeColor: strokeColor)
            x += dayPercentage * bounds.width
        }
    }

    func drawPath(x: CGFloat, width: CGFloat, height: CGFloat, strokeColor: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: bounds.origin.y - width / 2))
        path.addLine(to: CGPoint(x: x + width, y: bounds.origin.y - width / 2))
        path.close()
        path.lineWidth = bounds.width
        strokeColor.set()
        path.stroke()
        path.fill()
    }
}

import KikoModels
import KikoUIKit

class LineDrawingView: UIView {
    var moodCount: MonthData.MoodCount?

    func update(moodCount: MonthData.MoodCount) {
        self.moodCount = moodCount
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let moodCount = moodCount else { return }

//        for i in 0..<4 {
//            let moodType = unwrapOrElse(MoodType(rawValue: i), fallback: MoodType.chick)
//            let dayPercentage = CGFloat(monthData.countOf(moodType: moodType)) / CGFloat(monthData.totalDays)
//            let strokeColor = unwrapOrElse(MoodUISetting(rawValue: i)?.backgroundColor, fallback: UIColor.backgroundYellow)
//
//        }


    }
}

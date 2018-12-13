import KikoModels
import KikoUIKit

class MonthResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var circleView: ArcDrawingView!
    @IBOutlet weak var sundayBar: LineDrawingView!
    @IBOutlet weak var mondayBar: LineDrawingView!
    @IBOutlet weak var tuesdayBar: LineDrawingView!
    @IBOutlet weak var wednesdayBar: LineDrawingView!
    @IBOutlet weak var thursdayBar: LineDrawingView!
    @IBOutlet weak var fridayBar: LineDrawingView!
    @IBOutlet weak var saturdayBar: LineDrawingView!
    @IBOutlet weak var meditationCount: UILabel!

    private var monthData: MonthData?

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        monthLabel.text = nil
        meditationCount.text = nil
    }

    private func setup() {
        backgroundColor = .monthResultBackground
        circleView.backgroundColor = .clear
    }

    func configure(with monthData: MonthData) {
        self.monthData = monthData
        monthLabel.text = monthData.month.description
        circleView.update(monthData: monthData)
        sundayBar.update(monthData: monthData, day: .sunday)
        mondayBar.update(monthData: monthData, day: .monday)
        tuesdayBar.update(monthData: monthData, day: .tuesday)
        wednesdayBar.update(monthData: monthData, day: .wednesday)
        thursdayBar.update(monthData: monthData, day: .thursday)
        fridayBar.update(monthData: monthData, day: .friday)
        saturdayBar.update(monthData: monthData, day: .saturday)
    }
}

import KikoModels
import KikoUIKit

class MoodListCollectionViewCell: UICollectionViewCell, ViewStylePreparing {

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

    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!

    private let weekdayColor = UIColor.purple04.withAlphaComponent(0.6)
    private let monthColor = UIColor.purple04.withAlphaComponent(0.6)
    private let weekdayFont = UIFont.customFont(ofSize: 17, weight: .medium)

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

    func setupColors() {
        backgroundColor = .monthResultBackground
        circleView.backgroundColor = .clear
        sundayLabel.textColor = weekdayColor
        mondayLabel.textColor = weekdayColor
        tuesdayLabel.textColor = weekdayColor
        wednesdayLabel.textColor = weekdayColor
        thursdayLabel.textColor = weekdayColor
        fridayLabel.textColor = weekdayColor
        saturdayLabel.textColor = weekdayColor
        monthLabel.textColor = monthColor
    }

    func setupFonts() {
        monthLabel.font = UIFont.customFont(ofSize: 18, weight: .heavy)
        sundayLabel.font = weekdayFont
        mondayLabel.font = weekdayFont
        tuesdayLabel.font = weekdayFont
        wednesdayLabel.font = weekdayFont
        thursdayLabel.font = weekdayFont
        fridayLabel.font = weekdayFont
        saturdayLabel.font = weekdayFont
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

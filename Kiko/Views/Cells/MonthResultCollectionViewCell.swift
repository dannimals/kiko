import KikoModels
import KikoUIKit

struct MonthData {
    typealias MoodCount = [MoodType: Int]

    let countOfMon: MoodCount
    let countOfTues: MoodCount
    let countOfWed: MoodCount
    let countOfThurs: MoodCount
    let countOfFri: MoodCount
    let countOfSat: MoodCount
    let countOfSun: MoodCount
    let totalDays: Int

    func countOf(moodType: MoodType) -> Int {
        return unwrapOrEmpty(countOfMon[moodType])
            + unwrapOrEmpty(countOfTues[moodType])
            + unwrapOrEmpty(countOfWed[moodType])
            + unwrapOrEmpty(countOfThurs[moodType])
            + unwrapOrEmpty(countOfFri[moodType])
            + unwrapOrEmpty(countOfSat[moodType])
            + unwrapOrEmpty(countOfSun[moodType])
    }
}

class MonthResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var circleView: ArcDrawingView!
    @IBOutlet weak var sundayBar: UIView!
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
        monthLabel.textColor = .lightGreyBlue
    }

    func configure(with monthData: MonthData) {
        self.monthData = monthData
        self.monthLabel.text = "June"
        circleView.update(monthData: monthData)
    }
}

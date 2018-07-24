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
}

class MonthResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var sundayBar: UIView!
    @IBOutlet weak var meditationCount: UILabel!

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
    }

    func configure(with monthData: MonthData) {
        
    }
}

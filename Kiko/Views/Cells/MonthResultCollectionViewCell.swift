import KikoModels
import KikoUIKit

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

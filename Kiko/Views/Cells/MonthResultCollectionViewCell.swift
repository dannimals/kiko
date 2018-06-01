
import KikoModels
import KikoUIKit

class MonthResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var sundayBar: UIView!
    @IBOutlet weak var meditationCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        monthLabel.text = nil
        meditationCount.text = nil
    }
}

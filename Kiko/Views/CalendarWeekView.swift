
import KikoUIKit

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        datesCollectionView.backgroundColor = backgroundColor
    }
}

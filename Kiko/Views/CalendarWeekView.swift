
import KikoUIKit

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: UICollectionView!

    private var maxOffset: CGFloat = 0
    private var minOffset: CGFloat = 0

    func configure(dataSource: UICollectionViewDataSource & UICollectionViewDelegate) {
        datesCollectionView.dataSource = dataSource
        datesCollectionView.delegate = dataSource
        maxOffset = 326//bounds.width
    }

    func updateViewColor(_ color: UIColor = .salmonPink) {
        UIView.animate(withDuration: 0.4) {
            self.monthLabel.textColor = color
            self.leftButton.tintColor = color
            self.rightButton.tintColor = color
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        updateViewColor()
        datesCollectionView.backgroundColor = backgroundColor
    }

    private func animateOffsetX(_ offsetX: CGFloat) {
        UIView.animate(withDuration: 0.0) {
            self.datesCollectionView.contentOffset.x = offsetX
        }
    }
}

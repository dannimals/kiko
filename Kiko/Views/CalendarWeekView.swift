
import KikoUIKit

class CalendarWeekView: UIView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var datesCollectionView: UICollectionView!

    private var maxOffset: CGFloat = 0
    private var minOffset: CGFloat = 0

    func configure(dataSource: UICollectionViewDataSource) {
        datesCollectionView.dataSource = dataSource
        datesCollectionView.delegate = self
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

extension CalendarWeekView: UICollectionViewDelegate {

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var offsetX = scrollView.contentOffset.x
//        if offsetX < minOffset {
//            offsetX = minOffset
//            animateOffsetX(offsetX)
//            scrollView.panGestureRecognizer.isEnabled = false
//            scrollView.panGestureRecognizer.isEnabled = true
//            minOffset -= 325//bounds.width
//        } else if offsetX > minOffset + 325 / 2 {
//            offsetX = maxOffset
//            animateOffsetX(offsetX)
//            scrollView.panGestureRecognizer.isEnabled = false
//            scrollView.panGestureRecognizer.isEnabled = true
//            maxOffset += 325//bounds.width
//        }
//    }
}

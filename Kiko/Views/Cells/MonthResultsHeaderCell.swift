import KikoModels
import KikoUIKit

class MonthResultHeaderCell: UICollectionReusableView {

    static let reuseIdentifier = "MonthResultHeaderCell"

    let yearLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func configure(year: Int) {
        yearLabel.text = String(year)
    }

    private func setup() {
        yearLabel.font = UIFont.customFont(ofSize: 25, weight: .medium)
        yearLabel.textColor = UIColor.lightGreyBlue
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        yearLabel.text = nil
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

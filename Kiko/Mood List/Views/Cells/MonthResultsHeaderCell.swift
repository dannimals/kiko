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
        yearLabel.textColor = .white
        addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        yearLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        yearLabel.text = nil
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

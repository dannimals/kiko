import KikoModels
import KikoUIKit

class MoodListHeaderCell: UICollectionReusableView {

    let yearLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func configure(year: Int) {
        yearLabel.text = String(year)
    }

    private func setup() {
        yearLabel.font = UIFont.customFont(ofSize: 24, weight: .heavy)
        yearLabel.textColor = .blue06
        addSubview(yearLabel)
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        yearLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        yearLabel.text = nil
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

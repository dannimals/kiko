
import KikoUIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {

    var isDaySelected = false
    private let dateLabel = UILabel()
    private let backgroundCircleView = UIView()
    private let indicatorCircle = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    func configure(date: Int) {
        dateLabel.text = date.description
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()

        configureForReuse()
    }

    private func configure() {
        configureForReuse()
        configureBackgroundCircle()
        configureIndicatorCircle()
        configureDateLabel()
    }

    private func configureDateLabel() {
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = UIColor.textDarkGrey
        dateLabel.font = UIFont.customFont(ofSize: 14, weight: .medium)
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    private func configureBackgroundCircle() {
        backgroundCircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundCircleView)
        backgroundCircleView.layer.cornerRadius = 17
        backgroundCircleView.backgroundColor = UIColor.indicatorGrey
        NSLayoutConstraint.activate([
            backgroundCircleView.heightAnchor.constraint(equalToConstant: 34),
            backgroundCircleView.widthAnchor.constraint(equalToConstant: 34),
            backgroundCircleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func configureIndicatorCircle() {
        indicatorCircle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(indicatorCircle)
        indicatorCircle.layer.cornerRadius = 3.5
        NSLayoutConstraint.activate([
            indicatorCircle.heightAnchor.constraint(equalToConstant: 7),
            indicatorCircle.widthAnchor.constraint(equalToConstant: 7),
            indicatorCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicatorCircle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2)
        ])
    }

    private func configureForReuse() {
        indicatorCircle.isHidden = true
        backgroundCircleView.isHidden = true
        dateLabel.font = UIFont.customFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = UIColor.textDarkGrey
    }
}

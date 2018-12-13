import KikoModels
import KikoUIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {

    var isToday = false
    var isDaySelected = false
    let dateLabel = UILabel()
    private let backgroundCircleView = UIView()
    private let moodIndicatorCircle = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    func configure(date: Date, today: Date, moodColor: UIColor?) {
        let isToday = date ≈≈ today
        self.isToday = isToday
        configureCircleViews(isToday: isToday, moodColor: moodColor)
        if isToday {
            configureDateLabel(font: .customFont(ofSize: 16, weight: .heavy), textColor: .todayGrey)
        } else if date < today {
            configureDateLabel(font: .customFont(ofSize: 14, weight: .medium), textColor: .textDarkGrey)
        } else {
            configureDateLabel(font: .customFont(ofSize: 14, weight: .light), textColor: .textLightGrey)
        }
        dateLabel.text = date.day.description
    }

    private func configureCircleViews(isToday: Bool, moodColor: UIColor?) {
        backgroundCircleView.isHidden = !isToday
        guard let moodColor = moodColor else { return }
        if isToday {
            backgroundCircleView.layer.borderWidth = 2
            backgroundCircleView.layer.borderColor = moodColor.cgColor
        } else {
            moodIndicatorCircle.isHidden = false
            moodIndicatorCircle.backgroundColor = moodColor
        }
    }

    private func configureDateLabel(font: UIFont, textColor: UIColor) {
        dateLabel.font = font
        dateLabel.textColor = textColor
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()

        configureForReuse()
    }

    private func configure() {
        configureForReuse()
        configureBackgroundCircle()
        configureMoodIndicatorCircle()
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
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
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

    private func configureMoodIndicatorCircle() {
        moodIndicatorCircle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moodIndicatorCircle)
        moodIndicatorCircle.layer.cornerRadius = 3.5
        NSLayoutConstraint.activate([
            moodIndicatorCircle.heightAnchor.constraint(equalToConstant: 7),
            moodIndicatorCircle.widthAnchor.constraint(equalToConstant: 7),
            moodIndicatorCircle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moodIndicatorCircle.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    private func configureForReuse() {
        moodIndicatorCircle.isHidden = true
        backgroundCircleView.isHidden = true
        dateLabel.font = UIFont.customFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = UIColor.textDarkGrey
    }
}

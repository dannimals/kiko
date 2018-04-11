
import KikoUIKit
import KikoModels

class MoodLogView: UIView {

    private let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()
    private let greetingLabel = UILabel()
    private let greetingsLabel = UILabel()
    private let logButton = UIButton()
    private let moodImageView = UIImageView()
    private let moodScrollView = UIScrollView()
    private let ringButton = UIButton()
    private let wavesButton = UIButton()
    private var moodImages = [UIImageView]()

    func configure(dataSource: UICollectionViewDataSource) {
        calendarWeekView.configure(dataSource: dataSource)
        configure()
    }

    func reloadCalendarWeekData() {
        calendarWeekView.datesCollectionView.reloadData()
    }

    func updateMonth(_ month: Month) {
        calendarWeekView.monthLabel.text = "\(month)".capitalized
    }

    private func configureRingButton() {
        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringButton)
        ringButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 20).isActive = true
        ringButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20).isActive = true
    }

    private func configureWavesButton() {
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wavesButton)
        wavesButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -20).isActive = true
        wavesButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20).isActive = true
    }

    private func configureCalendarView() {
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarWeekView)
        NSLayoutConstraint.activate([
            calendarWeekView.topAnchor.constraint(equalTo: ringButton.bottomAnchor, constant: 24),
            calendarWeekView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarWeekView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    private func configureGreetingLabel() {
        let attributedText = NSAttributedString(string: "How are you ", attributes: [.font : UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor : UIColor.salmonPink])
        let mutableString = NSMutableAttributedString(attributedString: attributedText)
        let secondAttributedText = NSAttributedString(string: "today", attributes: [.font : UIFont.customFont(ofSize: 24, weight: .heavy), .foregroundColor : UIColor.salmonPink])
        let thirdAttributedText = NSAttributedString(string: "?", attributes: [.font : UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor : UIColor.salmonPink])
        mutableString.append(secondAttributedText)
        mutableString.append(thirdAttributedText)
        greetingLabel.attributedText = mutableString
        addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: calendarWeekView.bottomAnchor, constant: 30),
            greetingLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }

    private func configureMoodScrollView() {
        let chickImage = UIImageView(image: #imageLiteral(resourceName: "chick"))
        chickImage.contentMode = .center
        let chickShellImage = UIImageView(image: #imageLiteral(resourceName: "chickEgg"))
        chickShellImage.contentMode = .center
        let eggImage = UIImageView(image: #imageLiteral(resourceName: "egg"))
        eggImage.contentMode = .center
        let rottenEggImage = UIImageView(image: #imageLiteral(resourceName: "rottenEgg"))
        rottenEggImage.contentMode = .center
        moodImages.append(chickImage)
        moodImages.append(chickShellImage)
        moodImages.append(eggImage)
        moodImages.append(rottenEggImage)
        let stackView = UIStackView()
        stackView.contentMode = .scaleAspectFill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(chickImage)
        stackView.addArrangedSubview(chickShellImage)
        stackView.addArrangedSubview(eggImage)
        stackView.addArrangedSubview(rottenEggImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        moodScrollView.isPagingEnabled = true
        moodScrollView.delegate = self
        moodScrollView.alwaysBounceHorizontal = true
        moodScrollView.isDirectionalLockEnabled = true
        moodScrollView.translatesAutoresizingMaskIntoConstraints = false
        moodScrollView.showsVerticalScrollIndicator = false
        moodScrollView.showsHorizontalScrollIndicator = false
        addSubview(moodScrollView)
        NSLayoutConstraint.activate([
            moodScrollView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            moodScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moodScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moodScrollView.heightAnchor.constraint(equalToConstant: 260)
            ])

        moodScrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: moodScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: moodScrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: moodScrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 4 * bounds.width),
            stackView.trailingAnchor.constraint(equalTo: moodScrollView.trailingAnchor)
            ])
        moodScrollView.contentSize = stackView.bounds.size
    }

    private func configure() {
        calendarWeekView.datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        configureRingButton()
        configureWavesButton()
        configureCalendarView()
        configureGreetingLabel()
        configureMoodScrollView()
    }

}

extension MoodLogView: UIScrollViewDelegate {

    final func setSelectedIndex(_ index: Int) {
        guard index < moodImages.count else { return }

        let image = moodImages[index]
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.moodScrollView.setContentOffset(image.frame.origin, animated: true)
        })
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let index = Int(offSetX / width)
        setSelectedIndex(index)
    }
}

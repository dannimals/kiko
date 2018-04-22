
import KikoUIKit
import KikoModels

class MoodLogView: UIView {

    let ringButtonTapped = Channel<UIControlEvents>()
    let wavesButtonTapped = Channel<UIControlEvents>()
    let logButtonTapped = Channel<UIControlEvents>()

    private let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()
    private let greetingLabel = UILabel()
    private let logButton = LogButton()
    private let moodScrollView = UIScrollView()
    private let ringButton = UIButton()
    private let wavesButton = UIButton()
    private var moodImages = [UIImageView]()
    private var scrollIndicator = UIStackView()
    private var scrollIndicatorCircles = [UIView]()

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
        ringButton.setContentCompressionResistancePriority(.required, for: .vertical)
        ringButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        ringButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringButton)
        ringButton.leadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 20).isActive = true
        ringButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20).isActive = true
        ringButton.addTarget(self, action: #selector(notifyRingButtonTappedEvent), for: .touchUpInside)
    }

    @objc private func notifyRingButtonTappedEvent() { ringButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyWavesButtonTappedEvent() { wavesButtonTapped.broadcast(UIControlEvents.touchUpInside) }
    @objc private func notifyLogButtonTappedEvent() { logButtonTapped.broadcast(UIControlEvents.touchUpInside) }

    private func configureWavesButton() {
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.tintColor = .salmonPink
        wavesButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wavesButton)
        wavesButton.trailingAnchor.constraint(equalTo: safeTrailingAnchor, constant: -20).isActive = true
        wavesButton.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20).isActive = true
        wavesButton.addTarget(self, action: #selector(notifyWavesButtonTappedEvent), for: .touchUpInside)
    }

    private func configureCalendarView() {
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarWeekView)
        let topConstraint = calendarWeekView.topAnchor.constraint(equalTo: ringButton.bottomAnchor, constant: 45)
        topConstraint.priority = UILayoutPriority(rawValue: 750)
        NSLayoutConstraint.activate([
            topConstraint,
            calendarWeekView.topAnchor.constraint(greaterThanOrEqualTo: ringButton.bottomAnchor, constant: 15),
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
        greetingLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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

    private func circleViewWith(color: UIColor) -> UIView {
        let circleView = UIView()
        circleView.backgroundColor = color
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.cornerRadius = 11 / 2
        circleView.layer.masksToBounds = true
        circleView.widthAnchor.constraint(equalToConstant: 11).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 11).isActive = true
        return circleView
    }

    private func configureScrollIndicator() {
        let circle1 = circleViewWith(color: UIColor.salmonPink)
        let circle2 = circleViewWith(color: UIColor.salmonPink.faded)
        let circle3 = circleViewWith(color: UIColor.salmonPink.faded)
        let circle4 = circleViewWith(color: UIColor.salmonPink.faded)
        scrollIndicator.axis = .horizontal
        scrollIndicator.distribution = .equalCentering
        scrollIndicator.spacing = 7
        scrollIndicator.addArrangedSubview(circle1)
        scrollIndicator.addArrangedSubview(circle2)
        scrollIndicator.addArrangedSubview(circle3)
        scrollIndicator.addArrangedSubview(circle4)

        scrollIndicatorCircles.append(circle1)
        scrollIndicatorCircles.append(circle2)
        scrollIndicatorCircles.append(circle3)
        scrollIndicatorCircles.append(circle4)

        scrollIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollIndicator)
        NSLayoutConstraint.activate([
            scrollIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollIndicator.topAnchor.constraint(equalTo: moodScrollView.bottomAnchor, constant: 30),
            scrollIndicator.widthAnchor.constraint(equalToConstant: 65),
            scrollIndicator.heightAnchor.constraint(equalToConstant: 11)
        ])
    }

    private func configureLogButton() {
        logButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logButton)
        logButton.layer.cornerRadius = 16
        logButton.normalBackgroundColor = UIColor.salmonPink
        logButton.highlightedBackgroundColor = UIColor.selectedSalmonPink
        logButton.titleLabel?.font = UIFont.customFont(ofSize: 17, weight: .heavy)
        logButton.setTitle("Log", for: .normal)
        let bottomConstraint = logButton.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -35)
        bottomConstraint.priority = UILayoutPriority(rawValue: 750)
        NSLayoutConstraint.activate([
            bottomConstraint,
            logButton.topAnchor.constraint(greaterThanOrEqualTo: scrollIndicator.bottomAnchor, constant: 30),
            logButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logButton.heightAnchor.constraint(equalToConstant: 32),
            logButton.widthAnchor.constraint(equalToConstant: 74),
            logButton.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -30)
        ])
        logButton.addTarget(self, action: #selector(notifyLogButtonTappedEvent), for: .touchUpInside)
    }

    private func configure() {
        calendarWeekView.datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        configureRingButton()
        configureWavesButton()
        configureCalendarView()
        configureGreetingLabel()
        configureMoodScrollView()
        configureScrollIndicator()
        configureLogButton()
    }

}

extension MoodLogView: UIScrollViewDelegate {

    private func scrollToMoodImageForSelectedIndex(_ index: Int) {
        guard index < moodImages.count else { return }

        let image = moodImages[index]
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.moodScrollView.setContentOffset(image.frame.origin, animated: true)
        })
    }

    private func updateScrollIndicatorForSelectedIndex(_ index: Int) {
        guard index < scrollIndicatorCircles.count, let setting = MoodUISetting(rawValue: index) else { return }

        var allIndicators = scrollIndicatorCircles
        let selectedIndicator = scrollIndicatorCircles[index]
        allIndicators.remove(at: index)
        UIView.animate(withDuration: 0.4) {
            selectedIndicator.backgroundColor = setting.accessoryColor
            allIndicators.forEach {$0.backgroundColor = setting.accessoryColor.faded }
        }
    }

    private func updateViewColorsForSelectedIndex(_ index: Int) {
        guard let setting = MoodUISetting(rawValue: index) else { return }

        UIView.animate(withDuration: 0.4) {
            self.calendarWeekView.updateViewColor(setting.accessoryColor)
            self.backgroundColor = setting.backgroundColor
            self.greetingLabel.textColor = setting.accessoryColor
            self.logButton.normalBackgroundColor = setting.accessoryColor
            self.logButton.highlightedBackgroundColor = setting.selectedAccessoryColor
            self.wavesButton.tintColor = setting.accessoryColor
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let index = Int(offSetX / width)
        scrollToMoodImageForSelectedIndex(index)
        updateScrollIndicatorForSelectedIndex(index)
        updateViewColorsForSelectedIndex(index)
    }

    class LogButton: UIButton {
        var highlightedBackgroundColor: UIColor?
        var normalBackgroundColor: UIColor? {
            didSet {
                backgroundColor = normalBackgroundColor
            }
        }

        override var isHighlighted: Bool {
            didSet {
                backgroundColor = isHighlighted ? highlightedBackgroundColor : normalBackgroundColor
            }
        }
    }
}
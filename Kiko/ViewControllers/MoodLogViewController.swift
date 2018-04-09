
import KikoModels
import KikoUIKit

class MoodLogViewController: BaseViewController {
    private let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()
    private let greetingsLabel = UILabel()
    private let logButton = UIButton()
    private let moodImageView = UIImageView()
    private let ringButton = UIButton()
    private let wavesButton = UIButton()
    private let moodView = UIImageView()
    private let moodScrollView = UIScrollView()
    private let greetingLabel = UILabel()
    private let calendarManager: CalendarManager

    required init(calendarManager: CalendarManager) {
        self.calendarManager = calendarManager

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupDataSources()
    }

    private func setupDataSources() {
        calendarWeekView.datesCollectionView.dataSource = self
    }

    private func configureRingButton() {
        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ringButton)
        ringButton.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 20).isActive = true
        ringButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20).isActive = true
    }

    private func configureWavesButton() {
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wavesButton)
        wavesButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -20).isActive = true
        wavesButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20).isActive = true
    }

    private func configureCalendarView() {
        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarWeekView)
        NSLayoutConstraint.activate([
            calendarWeekView.topAnchor.constraint(equalTo: ringButton.bottomAnchor, constant: 24),
            calendarWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarWeekView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: calendarWeekView.bottomAnchor, constant: 30),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureMoodScrollView() {
        let chickImage = UIImageView(image: #imageLiteral(resourceName: "chick"))
        chickImage.contentMode = .scaleAspectFit
        let chickShellImage = UIImageView(image: #imageLiteral(resourceName: "chickEgg"))
        chickShellImage.contentMode = .scaleAspectFit
        let eggImage = UIImageView(image: #imageLiteral(resourceName: "egg"))
        eggImage.contentMode = .scaleAspectFit
        let rottenEggImage = UIImageView(image: #imageLiteral(resourceName: "rottenEgg"))
        rottenEggImage.contentMode = .center
        let stackView = UIStackView()
        stackView.contentMode = .scaleAspectFill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(chickImage)
        stackView.addArrangedSubview(chickShellImage)
        stackView.addArrangedSubview(eggImage)
        stackView.addArrangedSubview(rottenEggImage)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        moodScrollView.alwaysBounceHorizontal = true
        moodScrollView.isDirectionalLockEnabled = true
        moodScrollView.translatesAutoresizingMaskIntoConstraints = false
        moodScrollView.showsVerticalScrollIndicator = false
        moodScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(moodScrollView)
        NSLayoutConstraint.activate([
            moodScrollView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            moodScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moodScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moodScrollView.heightAnchor.constraint(equalToConstant: 260)
        ])

        moodScrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: moodScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: moodScrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: moodScrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 4 * view.bounds.width),
            stackView.trailingAnchor.constraint(equalTo: moodScrollView.trailingAnchor)
        ])
        moodScrollView.contentSize = stackView.bounds.size
    }

    private func configureViews() {
        view.backgroundColor = .backgroundYellow
        calendarWeekView.datesCollectionView.registerCell(CalendarDayCollectionViewCell.self)
        configureRingButton()
        configureWavesButton()
        configureCalendarView()
        configureGreetingLabel()
        configureMoodScrollView()
    }
}

extension MoodLogViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarManager.daysOfYear
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCollectionViewCell.identifier, for: indexPath) as? CalendarDayCollectionViewCell
            else { return UICollectionViewCell() }
        let date = calendarManager.currentDay
        dayCell.configure(date: date)
        return dayCell
    }
}

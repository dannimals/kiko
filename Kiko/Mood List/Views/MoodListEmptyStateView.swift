import KikoUIKit

class MoodListEmptyStateView: UIView {
    private let imageView = UIImageView()
    private let logButton = UIButton()
    let logButtonTapped = Channel<UIControlEvents>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        setupImageView()
        setupLogButton()
    }

    private func setupLogButton() {
        logButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logButton)
        logButton.layer.cornerRadius = 16
        logButton.backgroundColor = UIColor.backgroundBlue
        logButton.titleLabel?.font = UIFont.customFont(ofSize: 17, weight: .heavy)
        logButton.setTitle("Log a Mood", for: .normal)
        NSLayoutConstraint.activate([
            logButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logButton.heightAnchor.constraint(equalToConstant: 32),
            logButton.widthAnchor.constraint(equalToConstant: 135),
            logButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35)
            ])

        logButton.addTarget(self, action: #selector(notifyLogButtonTappedEvent), for: .touchUpInside)
    }

    @objc private func notifyLogButtonTappedEvent() {
        logButtonTapped.broadcast(UIControlEvents.touchUpInside)
    }

    private func setupImageView() {
        imageView.image = #imageLiteral(resourceName: "chickPainting")
        imageView.sizeToFit()
        imageView.center = CGPoint(x: center.x, y: center.y - 80)
        addSubview(imageView)
    }
}

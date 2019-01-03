
import KikoUIKit
import UIKit

protocol CreateMoodViewDelegate: class {

    func ringButtonTapped(_ button: UIButton)
    func wavesButtonTapped(_ button: UIButton)
    func logButtonTapped(_ button: UIButton)

}

class CreateMoodView: UIView, ViewStylePreparing, StoryboardNestable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var logButton: RoundedButton!
    @IBOutlet weak var pagingContainerView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusButtonContainer: UIView!
    @IBOutlet weak var plusButtonShadow: UIView!

    weak var delegate: CreateMoodViewDelegate!

    private let buttonsDrawerView = ButtonsDrawerView()
    private let ringButton = UIButton()
    private let wavesButton = UIButton()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadViewFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    @IBAction func ringButtonTapped(_ sender: UIButton) {
        toggleMenu()
        delegate.ringButtonTapped(sender)
    }
    @IBAction func wavesButtonTapped(_ sender: UIButton) {
        toggleMenu()
        delegate.wavesButtonTapped(sender)
    }
    @IBAction func logButtonTapped(_ sender: UIButton) {
        delegate.logButtonTapped(sender)
    }
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        toggleMenu()
    }

    func setupViews() {
        setupScrollView()
        setupButtons()
        setupButtonsDrawerView()
        setupBlurView()
    }

    func updateLogButton(hasMoodForToday: Bool) {
        let logButtonTitle = hasMoodForToday ? Glossary.update.rawValue : Glossary.log.rawValue
        logButton.title = logButtonTitle
    }

    func updateColorsForPage(_ page: MoodPageDisplay) {
        logButton.backgroundColor = page.accessoryColor
        logButton.highlightedBackgroundColor = page.accessoryColor.faded
        gradientView.colors = page.gradientColors
    }

    private func setupBlurView() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        blurView.addGestureRecognizer(tapGR)
    }

    @objc private func toggleMenu() {
        rotatePlusButton()
        toggleBlurView(duration: 0.2)
        buttonsDrawerView.toggle()
    }

    private func setupScrollView() {
        let animatedWavesView = AnimatedWavesView(frame: CGRect(origin: CGPoint(x: bounds.width, y: 0), size: bounds.size))
        scrollView.addSubview(animatedWavesView)
        scrollView.contentSize = CGSize(width: bounds.width * 2, height: bounds.height)
        scrollView.setContentOffset(CGPoint(x: bounds.width, y: 0), animated: false)
    }

    private func toggleBlurView(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.blurView.alpha = 0.8 - self.blurView.alpha
        }
    }

    private func rotatePlusButton() {
        let rotation = plusButton.transform.rotation
        let angle: CGFloat = rotation == 0 ? 45 : -45
        plusButton.rotate(by: angle)
    }

    private func setupButtonsDrawerView() {
        buttonsDrawerView.configure(buttons: [ringButton, wavesButton], initialOffset: plusButtonContainer.bounds.height + 32)
        addSubview(buttonsDrawerView)
        buttonsDrawerView.translatesAutoresizingMaskIntoConstraints = false
        buttonsDrawerView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor).isActive = true
        buttonsDrawerView.centerXAnchor.constraint(equalTo: plusButton.centerXAnchor).isActive = true
        insertSubview(plusButtonContainer, aboveSubview: buttonsDrawerView)
    }

    private func setupButtons() {
        logButton.setTitleColor(.white, for: .normal)
        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.bounds.size = CGSize(width: 40, height: 40)
        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.tintColor = .purple02
        wavesButton.bounds.size = CGSize(width: 40, height: 40)
        logButton.backgroundColor = .yellow04
        plusButton.adjustsImageWhenHighlighted = false
        plusButtonShadow.addShadow()
        wavesButton.addTarget(self, action: #selector(wavesButtonTapped), for: .touchUpInside)
        ringButton.addTarget(self, action: #selector(ringButtonTapped), for: .touchUpInside)
    }
}

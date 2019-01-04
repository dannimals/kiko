
import KikoUIKit

final class AnimatedWavesView: UIView, ViewStylePreparing, StoryboardNestable {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var fullMinButton: UIButton!
    @IBOutlet weak var halfMinButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIStackView!

    private let gradientLayer = AnimatedWavesGradientLayer()
    private let feedbackGenerator = AnimatedWavesFeedbackGenerator()
    private let footerViewAlpha: CGFloat = 0.6
    private var footerViewTimer: Timer?
    private let defaultFadeOutDelay: TimeInterval = 4
    private let defaultFadeOutDuration: TimeInterval = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadViewFromNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadViewFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    @IBAction func halfMinButtonTapped(_ sender: Any) {
        let image = halfMinButton.imageView?.image == #imageLiteral(resourceName: "30s") ? #imageLiteral(resourceName: "30sSelected") : #imageLiteral(resourceName: "30s")
        halfMinButton.setImage(image, for: .normal)
        fullMinButton.setImage(#imageLiteral(resourceName: "60s"), for: .normal)
        halfMinButton.imageView?.image == #imageLiteral(resourceName: "30s") ? feedbackGenerator.cancelHalfMinTimer() : feedbackGenerator.fireHalfMinTimer()
    }

    @IBAction func fullMinButtonTapped(_ sender: Any) {
        let image = fullMinButton.imageView?.image == #imageLiteral(resourceName: "60s") ? #imageLiteral(resourceName: "60sSelected") : #imageLiteral(resourceName: "60s")
        fullMinButton.setImage(image, for: .normal)
        halfMinButton.setImage(#imageLiteral(resourceName: "30s"), for: .normal)
        fullMinButton.imageView?.image == #imageLiteral(resourceName: "60s") ? feedbackGenerator.cancelFullMinTimer() :         feedbackGenerator.fireFullMinTimer()
    }

    @IBAction func modeButtonTapped(_ sender: Any) {
        let image = modeButton.imageView?.image == #imageLiteral(resourceName: "478") ? #imageLiteral(resourceName: "478Selected") : #imageLiteral(resourceName: "478")
        modeButton.setImage(image, for: .normal)
        gradientLayer.toggleMode()
    }

    func reset() {
        feedbackGenerator.reset()
    }

    func setupColors() {
        backgroundColor = .backgroundBlue
    }

    func setupViews() {
        setupGradientLayer()
        setupFooterView()
        setupTapGesture()
        fireFooterTimer()
    }

    private func setupFooterView() {
        bringSubview(toFront: footerView)
        guard !UIAccessibilityIsReduceTransparencyEnabled() else { return }
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.stretchToFill(parentView: footerView)
        footerView.insertSubview(blurView, belowSubview: buttonContainerView)
    }

    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(toggleFooter))
        addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func toggleFooter() {
        footerView.alpha == 0 ? showFooter() : hideFooter()
    }

    @objc private func hideFooter() {
        cancelFooterTimer()
        UIView.animate(withDuration: defaultFadeOutDuration, animations: {
            self.footerView.frame.origin = CGPoint(x: 0, y: self.frame.maxY)
        }, completion: { _ in self.footerView.alpha = 0.0 })
    }

    private func showFooter() {
        self.footerView.alpha = footerViewAlpha
        UIView.animate(withDuration: defaultFadeOutDuration) {
            self.footerView.frame.origin = CGPoint(x: 0, y: self.frame.maxY - self.footerView.bounds.height)
        }
        fireFooterTimer()
    }

    private func fireFooterTimer() {
        cancelFooterTimer()
        footerViewTimer = Timer.scheduledTimer(timeInterval: defaultFadeOutDelay, target: self, selector: #selector(hideFooter), userInfo: nil, repeats: false)
    }

    private func cancelFooterTimer() {
        footerViewTimer?.invalidate()
        footerViewTimer = nil
    }

    private func setupGradientLayer() {
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        gradientLayer.animate()
    }
}

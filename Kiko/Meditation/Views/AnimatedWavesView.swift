
import KikoUIKit

final class AnimatedWavesView: UIView, ViewStylePreparing, StoryboardNestable {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var footerView: UIView!
    private let gradientLayer = AnimatedWavesGradientLayer()
    private let footerViewAlpha: CGFloat = 0.6

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

    func setupColors() {
        backgroundColor = .backgroundBlue
        footerView.backgroundColor = UIColor.paleBlue.withAlphaComponent(footerViewAlpha)
    }

    func setupViews() {
        setupGradientLayer()
        setupFooterView()
        setupTapGesture()
    }

    private func setupFooterView() {
        bringSubview(toFront: footerView)
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = footerView.bounds
        footerView.addSubview(blurView)
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

    private func hideFooter() {
//        cancelTimer()
        UIView.animate(withDuration: 0.4, animations: {
            self.footerView.frame.origin = CGPoint(x: 0, y: self.frame.maxY)
        }, completion: { _ in self.footerView.alpha = 0.0 })
    }

    private func showFooter() {
//        startTimer()
        self.footerView.alpha = footerViewAlpha
        UIView.animate(withDuration: 0.4) {
            self.footerView.frame.origin = CGPoint(x: 0, y: self.frame.maxY - self.footerView.bounds.height)
        }
    }

    private func setupGradientLayer() {
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        gradientLayer.animate()
    }

}

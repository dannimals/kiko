
import KikoUIKit

final class AnimatedWavesView: UIView, ViewStylePreparing, StoryboardNestable {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    private let gradientLayer = AnimatedWavesGradientLayer()

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
        footerView.backgroundColor = .paleBlue
    }

    func setupViews() {
        setupGradientLayer()
        bringSubview(toFront: footerView)
    }

    private func setupGradientLayer() {
        gradientLayer.frame = frame
        layer.addSublayer(gradientLayer)
        gradientLayer.animate()
    }

}

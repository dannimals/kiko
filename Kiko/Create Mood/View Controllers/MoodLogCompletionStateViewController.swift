import KikoUIKit

class MoodLogCompletionStateViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private let blurEffect = UIBlurEffect(style: .light)
    private lazy var blurEffectView: UIVisualEffectView = {
        return UIVisualEffectView(effect: blurEffect)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func configure(withImage image: UIImage, imageColor: UIColor?) {
        imageView.image = image
        if let imageColor = imageColor {
            let rasterizedImage = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.image = rasterizedImage
            imageView.tintColor = imageColor
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showBlurEffectView()
        animateImageViewScale()
    }

    private func showBlurEffectView() {
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.insertSubview(blurEffectView, belowSubview: imageView)
    }

    func prepareForDismissal() {
        animateDismissImageView()
        animateHideBlurView()
    }

    private func setup() {
        view.backgroundColor = .clear
        imageView.transform = imageView.transform.scaledBy(x: 0, y: 0)
    }

    private func animateDismissImageView() {
        let finalPoint = view.bounds.height + imageView.bounds.height
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        positionAnimation.fromValue = view.center.y
        positionAnimation.toValue = finalPoint
        positionAnimation.duration = 0.3
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        imageView.layer.add(positionAnimation, forKey: nil)
        imageView.layer.position.y = finalPoint
    }

    private func animateHideBlurView() {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1.0
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.3
        fadeAnimation.setValue(blurEffectView.layer, forKey: "blurEffectLayer")
        fadeAnimation.delegate = self
        blurEffectView.layer.add(fadeAnimation, forKey: nil)
        blurEffectView.alpha = 0.0
    }

    private func animateImageViewScale() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 0.2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        imageView.transform = .identity
        imageView.layer.add(scaleAnimation, forKey: nil)
    }
}

extension MoodLogCompletionStateViewController: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let _ = anim.value(forKey: "blurEffectLayer") as? CALayer else { return }
        imageView.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
}

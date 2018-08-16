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

        animateImageView()

        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.insertSubview(blurEffectView, belowSubview: imageView)
    }

    private func setup() {
        view.backgroundColor = .clear
        imageView.transform = imageView.transform.scaledBy(x: 0, y: 0)
    }

    private func animateImageView() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 0.2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        imageView.transform = .identity
        imageView.layer.add(scaleAnimation, forKey: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        blurEffectView.removeFromSuperview()
    }
}

import KikoModels
import KikoUIKit

class AnimatedMaskButton: UIButton {

    var mainColor: UIColor? {
        didSet {
            needsUpdate()
        }
    }

    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let locations: [NSNumber] = [0.25, 0.5, 0.75]
        gradientLayer.locations = locations
        return gradientLayer
    }()

    func needsUpdate() {
        guard let image = imageView?.image else { return }
        let colors = [
            unwrapOrElse(mainColor, fallback: UIColor.lightBlue).cgColor,
            UIColor.white.cgColor,
            unwrapOrElse(mainColor, fallback: UIColor.lightBlue).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.colors = colors
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.frame = bounds.offsetBy(dx: bounds.size.width, dy: 0)
        maskLayer.contents = image.cgImage
        gradientLayer.mask = maskLayer
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 3 * bounds.size.width, height: bounds.size.height)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        layer.addSublayer(gradientLayer)
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [0.0, 0.0, 0.25 ]
        gradientAnimation.toValue = [0.75, 1.0, 1.0]
        gradientAnimation.duration = 3
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
}

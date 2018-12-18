
import UIKit

class GradientView: UIView {

    private enum GradientAnimationConstant {
        static let animationDuration: CFTimeInterval = 8
        static let locations: [NSNumber] = [0, 0.3, 0.7]
        static let endPoint = CGPoint(x: 0.75, y: 1)
        static let startPoint = CGPoint(x: 0.25, y: 0)
        static let startPointAnimationToValue = CGPoint(x: 1, y: 0.0)
        static let endPointAnimationToValue = CGPoint(x: 0.0, y: 1.2)
    }

    var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }

    public var colors: [CGColor] = [] {
        didSet {
            gradientLayer?.colors = colors
        }
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGradientLayer()
    }

    private func setupGradientLayer() {
        gradientLayer?.startPoint = GradientAnimationConstant.startPoint
        gradientLayer?.endPoint = GradientAnimationConstant.endPoint
        gradientLayer?.locations = GradientAnimationConstant.locations

        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        startPointAnimation.toValue = GradientAnimationConstant.startPointAnimationToValue

        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        endPointAnimation.toValue = GradientAnimationConstant.endPointAnimationToValue

        let gradientAnimation = CAAnimationGroup()
        gradientAnimation.duration = GradientAnimationConstant.animationDuration
        gradientAnimation.animations = [startPointAnimation, endPointAnimation]
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        gradientLayer?.add(gradientAnimation, forKey: nil)
    }
}

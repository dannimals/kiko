
import UIKit

class GradientView: UIView {

    private enum GradientAnimationConstant {
        static let colorDuration: CFTimeInterval = 0.6
        static let pointDuration: CFTimeInterval = 8
        static let locations: [NSNumber] = [0, 0.4, 0.9]
        static let startPoint = CGPoint(x: 0.25, y: 0)
        static let endPoint = CGPoint(x: 0.75, y: 1)
        static let startPointAnimationToValue = CGPoint(x: 0.75, y: 0.0)
        static let endPointAnimationToValue = CGPoint(x: 0.0, y: 1)
        static let colorAnimationKey = "changeColors"
    }

    let animation = CABasicAnimation(keyPath: "colors")

    var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }

    public var colors: [CGColor] = [] {
        didSet {
            animateUpdatedColors(colors)
        }
    }

    func animateUpdatedColors(_ colors: [CGColor]) {
        gradientLayer?.removeAnimation(forKey: GradientAnimationConstant.colorAnimationKey)
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gradientLayer?.colors = colors
        }
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.duration = GradientAnimationConstant.colorDuration
        colorAnimation.toValue = colors
        colorAnimation.fillMode = kCAFillModeForwards
        colorAnimation.isRemovedOnCompletion = false
        gradientLayer?.add(colorAnimation, forKey: GradientAnimationConstant.colorAnimationKey)
        CATransaction.commit()
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
        gradientAnimation.duration = GradientAnimationConstant.pointDuration
        gradientAnimation.animations = [startPointAnimation, endPointAnimation]
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        gradientLayer?.add(gradientAnimation, forKey: nil)
    }
}

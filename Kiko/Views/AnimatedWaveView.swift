
import KikoUIKit

final class AnimatedWaveView: UIView, ViewStylePreparing {

    private let gradientLayer = CAGradientLayer()
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let scaleFactor: CGFloat = 1.25
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0
    private let blurredCircle = UIView()

    private enum GradientAnimationConstant {
        static let animationDuration: CFTimeInterval = 10
        static let startPoint = CGPoint(x: 0.25, y: 0)
        static let endPoint = CGPoint(x: 0.75, y: 1)
        static let startPointAnimationToValue = CGPoint(x: 1, y: 0.0)
        static let endPointAnimationToValue = CGPoint(x: 0.0, y: 1.0)
        static let locations: [NSNumber] = [0.0, 0.3, 0.8]
        static let colors = [UIColor.purple02.withAlphaComponent(0.6).cgColor,
                             UIColor.purple02.cgColor,
                             UIColor.purple03.cgColor]
    }

    private enum WaveAnimationConstant {
        static let animationDuration: CFTimeInterval = 7
    }

    private enum WaveConstant {
        static let lineWidth: CGFloat = 4
        static let strokeColor = UIColor.waveBlue
        static let fillColor = UIColor.clear.cgColor
        static let waveCount = 10
        static let diameter: Double = 50
        static let offset: Double = 25
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func setupViews() {
        setupGradientLayer()
        setupWaves()
    }

    func setupAnimations() {
        animateGradientLayer()
        animateCurves()
    }

    private func setupGradientLayer() {
        gradientLayer.frame = frame
        gradientLayer.startPoint = GradientAnimationConstant.startPoint
        gradientLayer.endPoint = GradientAnimationConstant.endPoint
        gradientLayer.colors = GradientAnimationConstant.colors
        gradientLayer.locations = GradientAnimationConstant.locations
        layer.addSublayer(gradientLayer)
    }

    private func animateGradientLayer() {
        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        startPointAnimation.toValue = GradientAnimationConstant.startPointAnimationToValue

        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        endPointAnimation.toValue = GradientAnimationConstant.endPointAnimationToValue

        let gradientAnimation = CAAnimationGroup()
        gradientAnimation.duration = GradientAnimationConstant.animationDuration
        gradientAnimation.animations = [startPointAnimation, endPointAnimation]
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

    private func animateCurves() {
        let duration = WaveAnimationConstant.animationDuration / 2
        let waveCount = waveLayers.count
        let div = duration / Double(waveCount)

        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = div * Double(i)
            let fadeInDelay = duration - fadeOutDelay
            addWaveAnimation(to: wave, duration: duration, fadeOutDelay: fadeOutDelay, fadeInDelay: fadeInDelay)
        }
    }

    private func addWaveAnimation(to wave: CAShapeLayer, duration: Double, fadeOutDelay: Double, fadeInDelay: Double) {

        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = max(duration - fadeOutDelay, 0.2)
        fadeOutAnimation.beginTime = fadeOutDelay
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = max(duration - fadeInDelay, 0.2)
        fadeInAnimation.beginTime = fadeOutAnimation.beginTime + fadeOutAnimation.duration + fadeInDelay
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = fadeInAnimation.beginTime + fadeInAnimation.duration
        groupAnimation.animations = [fadeOutAnimation, fadeInAnimation]
        groupAnimation.repeatCount = .infinity

        wave.add(groupAnimation, forKey: "animateOpacity")
    }

    private func setupWaves() {
        layer.masksToBounds = true
        Array(1...WaveConstant.waveCount).forEach {
            let width = Double($0) * WaveConstant.offset + WaveConstant.diameter
            let rect = CGRect(x: 0, y: 0, width: width, height: width)
            let alpha = CGFloat($0) / CGFloat(WaveConstant.waveCount)
            let waveLayer = createWaveLayer(rect: rect, alphaComponent: alpha)
            layer.addSublayer(waveLayer)
            waveLayers.append(waveLayer)
        }
    }

    private func createWaveLayer(rect: CGRect, alphaComponent: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = center
        waveLayer.strokeColor = WaveConstant.strokeColor.withAlphaComponent(alphaComponent).cgColor
        waveLayer.fillColor = WaveConstant.fillColor
        waveLayer.lineWidth = WaveConstant.lineWidth
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
}


import KikoUIKit

final class AnimatedWavesGradientLayer: CAGradientLayer, ViewStylePreparing {

    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0

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

    override init() {
        super.init()

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setupViews() {
        setupGradientLayer()
        setupWaves()
    }

    func animate() {
        animateCurves()
        animateGradientLayer()
    }

    private func animateCurves() {
        let duration = WaveAnimationConstant.animationDuration / 2
        let div = duration / Double(WaveConstant.waveCount)

        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = div * Double(i)
            let fadeInDelay = duration - fadeOutDelay
            addWaveAnimation(to: wave, duration: duration, fadeOutDelay: fadeOutDelay, fadeInDelay: fadeInDelay)
        }
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
        add(gradientAnimation, forKey: nil)
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
        masksToBounds = true
        Array(0..<WaveConstant.waveCount).forEach {
            let width = Double($0) * WaveConstant.offset + WaveConstant.diameter
            let rect = CGRect(x: 0, y: 0, width: width, height: width)
            let alpha = CGFloat($0) / CGFloat(WaveConstant.waveCount)
            let waveLayer = createWaveLayer(rect: rect, alphaComponent: alpha)
            addSublayer(waveLayer)
            waveLayers.append(waveLayer)
        }
    }

    private func setupGradientLayer() {
        startPoint = GradientAnimationConstant.startPoint
        endPoint = GradientAnimationConstant.endPoint
        colors = GradientAnimationConstant.colors
        locations = GradientAnimationConstant.locations
    }

    private func createWaveLayer(rect: CGRect, alphaComponent: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        waveLayer.strokeColor = WaveConstant.strokeColor.withAlphaComponent(alphaComponent).cgColor
        waveLayer.fillColor = WaveConstant.fillColor
        waveLayer.lineWidth = WaveConstant.lineWidth
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }

}

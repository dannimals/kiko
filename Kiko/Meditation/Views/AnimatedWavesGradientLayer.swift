
import KikoUIKit

final class AnimatedWavesGradientLayer: CAGradientLayer, ViewStylePreparing {

    enum Mode: String {
        case normal
        case meditation

        static let waveAnimation = "waveAnimation"
    }

    private var mode: Mode = .normal { didSet { updateCurveAnimation() } }
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
        static let normalAnimationDuration: CFTimeInterval = 6
        static let fadeOutDuration: CFTimeInterval = 4
        static let pulseDuration: CFTimeInterval = 1// TESTTEST 7
        static let fadeInDuration: CFTimeInterval = 8
        static let pulseKey = "layerForPulseAnimation"
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

    func toggleMode() {
        mode = mode == .normal ? .meditation : .normal
    }

    func updateCurveAnimation() {
        removeCurveAnimations()
        switch mode {
        case .normal: animateCurvesForNormalMode()
        case .meditation: animateCurvesForMeditationMode()
        }
    }

    func setupViews() {
        setupGradientLayer()
        setupWaves()
    }

    func animate() {
        updateCurveAnimation()
        animateGradientLayer()
    }

    private func animateCurvesForMeditationMode() {
        let waves = waveLayers.dropLast()
        let fadeOutDuration = WaveAnimationConstant.fadeOutDuration
        let fadeInDuration = WaveAnimationConstant.fadeInDuration
        let fadeOutDiv = fadeOutDuration / Double(WaveConstant.waveCount - 1)
        let fadeInDiv = fadeInDuration / Double(WaveConstant.waveCount - 1)
        for (i, wave) in waves.enumerated() {
            let fadeOutDelay = fadeOutDiv * Double(i)
            let fadeInDelay = fadeInDiv * Double(WaveConstant.waveCount - 1 - i) + WaveAnimationConstant.pulseDuration
            addWaveMeditationAnimation(to: wave, fadeInDuration: fadeInDuration, fadeInDelay: fadeInDelay, fadeOutDuration: fadeOutDuration, fadeOutDelay: fadeOutDelay)
        }
        let lastWave = self.waveLayers.last!
//        addPulseAnimation(to: lastWave, duration: WaveAnimationConstant.pulseDuration)
    }

    private func addPulseAnimation(to wave: CAShapeLayer, duration: Double) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 7
        pulse.fromValue = 0.98
        pulse.toValue = 1.02
        pulse.autoreverses = true
//        pulse.fillMode = kCAFillModeForwards
        pulse.beginTime = 4
        pulse.delegate = self
//        pulse.setValue(wave, forKey: WaveAnimationConstant.pulseKey)
        wave.add(pulse, forKey: "pulse")
    }

    private func addWaveMeditationAnimation(to wave: CAShapeLayer, fadeInDuration: Double, fadeInDelay: Double, fadeOutDuration: Double, fadeOutDelay: Double) {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = max(fadeOutDuration - fadeOutDelay, 0.01)
        fadeOutAnimation.beginTime = fadeOutDelay
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = max(fadeInDuration - fadeInDelay, 0.01)
        fadeInAnimation.beginTime = fadeOutAnimation.beginTime + fadeOutAnimation.duration + fadeInDelay
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = fadeInAnimation.beginTime + fadeInAnimation.duration
        groupAnimation.animations = [fadeOutAnimation, fadeInAnimation]
        groupAnimation.repeatCount = .infinity

        wave.add(groupAnimation, forKey: Mode.waveAnimation)
    }

    private func animateCurvesForNormalMode() {
        let duration = WaveAnimationConstant.normalAnimationDuration / 2
        let div = duration / Double(WaveConstant.waveCount)

        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = div * Double(i)
            let fadeInDelay = duration - fadeOutDelay
            addWaveNormalAnimation(to: wave, duration: duration, fadeOutDelay: fadeOutDelay, fadeInDelay: fadeInDelay)
        }
    }

    private func removeCurveAnimations() {
        waveLayers.forEach { $0.removeAnimation(forKey: Mode.waveAnimation)}
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

    private func addWaveNormalAnimation(to wave: CAShapeLayer, duration: Double, fadeOutDelay: Double, fadeInDelay: Double) {

        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = max(duration - fadeOutDelay, 0.01)
        fadeOutAnimation.beginTime = fadeOutDelay
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = max(duration - fadeInDelay, 0.01)
        fadeInAnimation.beginTime = fadeOutAnimation.beginTime + fadeOutAnimation.duration + fadeInDelay
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = fadeInAnimation.beginTime + fadeInAnimation.duration
        groupAnimation.animations = [fadeOutAnimation, fadeInAnimation]
        groupAnimation.repeatCount = .infinity

        wave.add(groupAnimation, forKey: Mode.waveAnimation)
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

extension AnimatedWavesGradientLayer: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let layer = anim.value(forKey: WaveAnimationConstant.pulseKey) as? CAShapeLayer else { return }
        layer.removeAllAnimations()

    }
}

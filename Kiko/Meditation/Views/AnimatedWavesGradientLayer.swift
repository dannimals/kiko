
import KikoUIKit

final class AnimatedGradientLayer: CAGradientLayer, ViewStylePreparing {

    enum Mode: String {
        case normal
        case meditation

        static let waveAnimation = "waveAnimation"
    }

    private var mode: Mode = .normal { didSet { updateCurveAnimation() } }
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0
    private let animatedWaveView = AnimatedImageView()

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
        static let pulseDuration: CFTimeInterval = 1
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
        let pulseTimer1 = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (_) in
            self.addPulseAnimation(to: lastWave, key: "pulse")
            let secondPulseTimer = Timer.scheduledTimer(withTimeInterval: 8 + 4 + 3, repeats: true, block: { (_) in
                lastWave.removeAnimation(forKey: "pulse")
                self.addPulseAnimation(to: lastWave, key: "pulse")
            })
            self.pulseTimers.append(secondPulseTimer)
        }
        self.pulseTimers.append(pulseTimer1)
    }

    private var pulseTimers: [Timer] = []

    private func addPulseAnimation(to wave: CAShapeLayer, key: String) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 1
        pulse.toValue = 1.02
        pulse.autoreverses = true
        pulse.repeatCount = 3.5

        wave.add(pulse, forKey: key)
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
        fadeInAnimation.beginTime = fadeOutAnimation.beginTime + fadeOutAnimation.duration + fadeInDelay + 3.5
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
        waveLayers.last?.removeAnimation(forKey: "pulse")
        pulseTimers.forEach { $0.invalidate() }
        pulseTimers = []
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
        animatedWaveView.frame = frame
        addSublayer(animatedWaveView.layer)

//        masksToBounds = true
//        Array(0..<WaveConstant.waveCount).forEach {
//            let width = Double($0) * WaveConstant.offset + WaveConstant.diameter
//            let rect = CGRect(x: 0, y: 0, width: width, height: width)
//            let alpha = CGFloat($0) / CGFloat(WaveConstant.waveCount)
//            let waveLayer = createWaveLayer(rect: rect, alphaComponent: alpha)
//            addSublayer(waveLayer)
//            waveLayers.append(waveLayer)
//        }
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

class AnimatedImageView: UIImageView {

    private(set) var imageSequence: [UIImage] = []
    private let animationkey = "contents"

    func startAnimating(duration: TimeInterval, repeatCount: Float = .infinity) {
        animateImages(duration: duration, repeatCount: repeatCount)
        image = nil
    }

    func stopAnimation() {
        removeImageAnimation()
        image = imageSequence.first
    }

    func configure(resourcePrefix prefix: String, resourceType: String, imageCount: Int) {
        imageSequence = Array(0...imageCount).compactMap { index in
            let bundle = Bundle(for: AnimatedImageView.self)
            let imagePath = bundle.path(forResource: prefix + "\(index)", ofType: resourceType) ?? ""
            return UIImage(contentsOfFile: imagePath)
        }
        image = imageSequence.first
    }

    private func animateImages(duration: TimeInterval, repeatCount: Float) {
        layer.removeAnimation(forKey: animationkey)
        let animation = CAKeyframeAnimation(keyPath: animationkey)
        animation.repeatCount = repeatCount
        animation.calculationMode = kCAAnimationDiscrete
        animation.values = imageSequence.map { $0.cgImage as Any }
        animation.duration = duration
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        layer.contentsGravity = kCAGravityResizeAspect
        layer.masksToBounds = true
        layer.minificationFilter = kCAFilterTrilinear
        layer.magnificationFilter = kCAFilterTrilinear
        layer.add(animation, forKey: animationkey)
        image = imageSequence.first
    }

    private func removeImageAnimation() {
        layer.removeAnimation(forKey: animationkey)
    }
}

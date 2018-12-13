
import KikoUIKit

final class AnimatedWaveView: UIView, ViewStylePreparing {

    private let gradientLayer = CAGradientLayer()
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let scaleFactor: CGFloat = 1.25
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0
    private let blurredCircle = UIView()

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
        setupTimer()
    }

    private func setupTimer() {
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animateCurves), userInfo: nil, repeats: true)
    }

    private func setupBlurredCircle() {
        let diameter: CGFloat = 130
        let rect = CGRect(origin: center, size: CGSize(width: diameter, height: diameter))
        blurredCircle.frame = rect
        blurredCircle.cornerRadius = diameter / 2
        blurredCircle.center = center
        blurredCircle.backgroundColor = UIColor.waveBlue
        blurredCircle.alpha = 0.5
        blurredCircle.layer.shadowColor = UIColor.backgroundBlue.cgColor
        blurredCircle.layer.shadowOffset = CGSize(width: 0, height: 1)
        blurredCircle.layer.shadowOpacity = 1
        blurredCircle.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: diameter / 2).cgPath
        addSubview(blurredCircle)
    }

    private func animateBlurredCircle() {
        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
        fadeOutAnimation.fromValue = 1
        fadeOutAnimation.toValue = 0
        fadeOutAnimation.duration = 4
        fadeOutAnimation.autoreverses = true
        fadeOutAnimation.repeatCount = .infinity
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        blurredCircle.layer.add(fadeOutAnimation, forKey: "opacity")
    }

    private func setupGradientLayer() {
        gradientLayer.frame = frame
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.purple03.withAlphaComponent(0.3).cgColor,
                                UIColor.purple03.withAlphaComponent(0.6).cgColor,
                                UIColor.purple03.cgColor]
        gradientLayer.locations = [0.0, 0.25, 0.65]
        layer.addSublayer(gradientLayer)
    }

    private func animateGradientLayer() {
        let animationDuration: CFTimeInterval = 30

        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        endPointAnimation.toValue = CGPoint(x: 1.0, y: 0.25)

        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        startPointAnimation.toValue = CGPoint(x: 0.0, y: 0.5)

        let gradientAnimation = CAAnimationGroup()
        gradientAnimation.duration = animationDuration
        gradientAnimation.animations = [startPointAnimation, endPointAnimation]
        gradientAnimation.autoreverses = true
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

    @objc func animateCurves() {
        let duration = 2.5
        let waveCount = waveLayers.count
        let div = duration / Double(waveCount)
        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = div * Double(i)
            let fadeInDelay = duration - fadeOutDelay
            addAnimation(to: wave, duration: duration, fadeOutDelay: fadeOutDelay, fadeInDelay: fadeInDelay)
        }
    }

    private func addAnimation(to wave: CAShapeLayer, duration: Double, fadeOutDelay: Double, fadeInDelay: Double) {

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

        wave.add(groupAnimation, forKey: "animateOpacity")
    }

    private func setupWaves() {
        layer.masksToBounds = true
        let waveCount = 10
        let baseDiameter: Double = 50
        let offset: Double = 25
        Array(1...waveCount).forEach {
            let width = Double($0) * offset + baseDiameter
            let rect = CGRect(x: 0, y: 0, width: width, height: width)
            let alpha = CGFloat($0) / CGFloat(waveCount)
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
        waveLayer.strokeColor = UIColor.waveBlue.withAlphaComponent(alphaComponent).cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 4
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

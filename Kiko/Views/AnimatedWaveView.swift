
import KikoUIKit

final class AnimatedWaveView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let scaleFactor: CGFloat = 1.25
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0
    private let blurredCircle = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGradientLayer()
//        setupBlurredCircle()
        setupWaves()
        animateCurves()
//        animateBlurredCircle()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animateCurves),
                             userInfo: nil, repeats: true)
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
        gradientLayer.colors = [UIColor.lightBackgroundBlue.cgColor, UIColor.darkBackgroundBlue.cgColor, UIColor.lightBackgroundBlue.cgColor]
        gradientLayer.locations = [0.0, 0.5, 0.8]
        layer.addSublayer(gradientLayer)
    }

    @objc func animateCurves() {
        let duration = 2.0
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
        fadeOutAnimation.duration = max(duration - fadeOutDelay, 0.1)
        fadeOutAnimation.beginTime = fadeOutDelay
        fadeOutAnimation.fillMode = kCAFillModeForwards
        fadeOutAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 2
        fadeInAnimation.beginTime = fadeOutAnimation.beginTime + fadeOutAnimation.duration + fadeInDelay
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fadeInAnimation.fillMode = kCAFillModeForwards

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = fadeInAnimation.beginTime + fadeInAnimation.duration

        groupAnimation.animations = [fadeOutAnimation, fadeInAnimation]
        wave.add(groupAnimation, forKey: "animateOpacity")
    }

    private func setupWaves() {
        layer.masksToBounds = true
        var i = 1.0
        let baseDiameter = 150.0
        var rect = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        while i < 100 && frame.contains(rect) {
            let waveLayer = addWaveLayer(rect: rect)
            layer.addSublayer(waveLayer)
            waveLayers.append(waveLayer)
            i += 1
            rect = CGRect(x: 0, y: 0, width: baseDiameter + i * 10, height: baseDiameter + 10 * i)
        }
    }

    private func addWaveLayer(rect: CGRect) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = center
        waveLayer.strokeColor = UIColor.waveBlue.cgColor
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.lineWidth = 1.0
        waveLayer.path = circlePath.cgPath
        waveLayer.strokeStart = 0
        waveLayer.strokeEnd = 1
        return waveLayer
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

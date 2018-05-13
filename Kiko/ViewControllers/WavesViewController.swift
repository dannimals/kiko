
import KikoUIKit

class WavesViewController: UIViewController {
    var wavesView: AnimatedWaveView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }

    override func loadView() {
        super.loadView()

        let customView = UIView()
        customView.backgroundColor = UIColor.backgroundBlue
        wavesView = AnimatedWaveView(frame: view.frame)
        customView.addSubview(wavesView)
        self.view = customView
    }

    private func configureBackButton() {
        let backButton = TappableButton()
        let image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.paleBlue
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() { navigationController?.popViewController(animated: true) }
}

final class AnimatedWaveView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let scaleFactor: CGFloat = 1.25
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupGradientLayer()
        createWaves()
        animateCurves()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animateCurves),
                                               userInfo: nil, repeats: true)
    }

    private func setupGradientLayer() {

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

    func createWaves() {
        layer.masksToBounds = true
        var i = 1.0
        let baseDiameter = 150.0
        var rect = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        while i < 100 && frame.contains(rect) {
            let waveLayer = createWaveLayer(rect: rect)
            layer.addSublayer(waveLayer)
            waveLayers.append(waveLayer)
            i += 1
            rect = CGRect(x: 0, y: 0, width: baseDiameter + i * 10, height: baseDiameter + 10 * i)
        }
    }

    private func createWaveLayer(rect: CGRect) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: rect)
        let waveLayer = CAShapeLayer()
        waveLayer.bounds = rect
        waveLayer.frame = rect
        waveLayer.position = self.center
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

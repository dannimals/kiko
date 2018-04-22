
import KikoUIKit

class WavesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }

    override func loadView() {
        super.loadView()

        let customView = UIView()
        customView.backgroundColor = UIColor.backgroundBlue
        let wavesView = AnimatedWaveView(frame: view.frame)
        customView.addSubview(wavesView)
        self.view = customView
    }

    private func configureBackButton() {
        let backButton = UIButton()
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

    private let baseRect = CGRect(x: 0, y: 0, width: 25, height: 25)
    private let scaleFactor: CGFloat = 1.25
    private var waveLayers: [CAShapeLayer] = []
    private var totalDuration: CGFloat = 2.0

    public func animateWaves() {
//        DispatchQueue.main.async {
//            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addAnimatedCurve), userInfo: nil, repeats: true)
//        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        createWaves()
        let totalDuration = 2.0
        let waveCount = waveLayers.count
        let div = totalDuration / Double(waveCount)
        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = Double(totalDuration) - Double(waveCount - i) * Double(div)
            let fadeInDelay = Double(totalDuration) - fadeOutDelay
            addFadeOutAnimation(to: wave, duration: totalDuration, delay: fadeOutDelay)
        }
    }

    func addFadeOutAnimation(to wave: CAShapeLayer, duration: Double, delay: Double) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { wave.opacity = 0 }
        let fadeAnimation = createFadeOutAnimation(delay: delay, duration: duration)
        wave.add(fadeAnimation, forKey: "opacity")
        wave.opacity = 0
        CATransaction.commit()

    }

    private func createFadeOutAnimation(delay: Double, duration: Double) -> CABasicAnimation {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.duration = duration
        fadeAnimation.beginTime = CACurrentMediaTime() + delay
        fadeAnimation.fillMode = kCAFillModeBackwards

        return fadeAnimation
    }

    func createWaves() {
        layer.masksToBounds = true
        var i = 1.0
        let baseDiameter = 150.0
        var rect = CGRect(x: 0, y: 0, width: baseDiameter, height: baseDiameter)
        while i < 3 { //frame.contains(rect) {
            let waveLayer = createWaveLayer(rect: rect)
            layer.addSublayer(waveLayer)
            waveLayers.append(waveLayer)
            i += 1
            rect = CGRect(x: 0, y: 0, width: baseDiameter * i, height: baseDiameter * i)
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

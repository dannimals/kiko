
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
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.animateCurves), userInfo: nil, repeats: true)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        createWaves()
        animateCurves()
        animateWaves()
    }

    @objc func animateCurves() {
        let totalDuration = 2.0
        let waveCount = waveLayers.count
        let div = totalDuration / Double(waveCount)
        for (i, wave) in waveLayers.enumerated() {
            let fadeOutDelay = Double(totalDuration) - Double(waveCount - i) * Double(div)
            addFadeOutAnimation(to: wave, duration: totalDuration, fadeOutDelay: fadeOutDelay)
        }
    }

    func addFadeOutAnimation(to wave: CAShapeLayer, duration: Double, fadeOutDelay: Double) {
        CATransaction.begin()
        let fadeOutAnimation = createFadeAnimation(delay: fadeOutDelay, duration: duration, fromValue: 1, toValue: 0)
        CATransaction.setCompletionBlock {
            let fadeInDelay = duration - fadeOutDelay
            self.addFadeInAnimation(to: wave, duration: duration, fadeInDelay: fadeInDelay)
        }
        fadeOutAnimation.fillMode = kCAFillModeBackwards
        wave.add(fadeOutAnimation, forKey: "opacity")
        wave.opacity = 0
        CATransaction.commit()
    }

    func addFadeInAnimation(to wave: CAShapeLayer, duration: Double, fadeInDelay: Double) {
        CATransaction.begin()
        let fadeInAnimation = createFadeAnimation(delay: fadeInDelay, duration: duration, fromValue: 0, toValue: 1)
        fadeInAnimation.fillMode = kCAFillModeBackwards
        wave.add(fadeInAnimation, forKey: "opacity")
        wave.opacity = 1
        CATransaction.commit()
    }

    private func createFadeAnimation(delay: Double, duration: Double, fromValue: Int, toValue: Int) -> CABasicAnimation {
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = fromValue
        fadeAnimation.toValue = toValue
        fadeAnimation.duration = duration
        fadeAnimation.beginTime = CACurrentMediaTime() + delay
//        fadeAnimation.repeatCount = Float.infinity

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


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
//        wavesView.animateWaves()
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
    private let waves: [CAShapeLayer] = []

    public func animateWaves() {
        DispatchQueue.main.async {
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.addAnimatedCurve), userInfo: nil, repeats: true)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        createWaves()
    }

    private func createWaves() {
        let baseRect = CGRect(x: 0, y: 0, width: 200, height: 200)

        let waveLayer = CALayer()
        waveLayer.frame = baseRect
        waveLayer.position = center
        waveLayer.borderColor = UIColor.paleBlue.cgColor
        waveLayer.borderWidth = 1.0
        waveLayer.cornerRadius = waveLayer.bounds.height / 2

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = 1
        fadeOut.repeatCount = Float.greatestFiniteMagnitude
        waveLayer.add(fadeOut, forKey: nil)

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.addSublayer(waveLayer)
        replicatorLayer.frame = frame
        replicatorLayer.instanceCount = 13
        replicatorLayer.instanceTransform = CATransform3DMakeScale(1.1, 1.1, 1)
        layer.addSublayer(replicatorLayer)
    }

    @objc private func addAnimatedCurve() {
        let waveLayer = createWaveLayer(rect: baseRect)
        layer.addSublayer(waveLayer)
        animateWaveLayer(waveLayer)
    }

    private func animateWaveLayer(_ waveLayer: CAShapeLayer) {
        let finalRect = bounds.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let finalPath = UIBezierPath(ovalIn: finalRect)
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = waveLayer.path
        pathAnimation.toValue = finalPath.cgPath

        let positionAnimation = CABasicAnimation(keyPath: "bounds")
        positionAnimation.fromValue = waveLayer.bounds
        positionAnimation.toValue = finalRect

        let scaleWave = CAAnimationGroup()
        scaleWave.animations = [pathAnimation, positionAnimation]
        scaleWave.duration = 10
        scaleWave.setValue(waveLayer, forKey: "waveLayer")
        scaleWave.delegate = self
        scaleWave.isRemovedOnCompletion = true
        waveLayer.add(scaleWave, forKey: "scale_wave_animation")
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

extension AnimatedWaveView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let waveLayer = anim.value(forKey: "waveLayer") as? CAShapeLayer {
            waveLayer.removeFromSuperlayer()
        }
    }
}

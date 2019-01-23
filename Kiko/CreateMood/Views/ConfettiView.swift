
import KikoUIKit

class ConfettiView: UIView, ViewStylePreparing {

    private var velocities = [250, 300, 350, 400]
    private var imagesNames = ["oval", "circle", "star", "triangle"]
    private var colors: [UIColor] = [.red04, .green04, .blue04, .yellow04]

    private let emitterLayer = CAEmitterLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setupViews() {
        backgroundColor = .clear
        setupConfettiEmitterLayer()
        emitterLayer.emitterCells = generateEmitterCells()
        layer.addSublayer(emitterLayer)
    }

    private func setupConfettiEmitterLayer() {
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: 2)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)
    }

    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()

        for index in 0..<10 {
            let cell = CAEmitterCell()
            cell.contents = image(atIndex: index)
            cell.color = colors[randomNumber].cgColor
            cell.birthRate = 2.0
            cell.lifetime = 3
            cell.lifetimeRange = 3
            cell.scale = 0.3
            cell.scaleRange = 0.25
            cell.velocity = CGFloat(randomVelocity)
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 1
            cells.append(cell)
        }

        return cells
    }

    var randomNumber: Int {
        return Int(arc4random_uniform(UInt32(imagesNames.count)))
    }

    var randomVelocity: Int {
        return velocities[randomNumber]
    }

    private func image(atIndex index: Int) -> CGImage? {
        let image = UIImage(named: imagesNames[index % imagesNames.count])
        return image?.cgImage
    }
}

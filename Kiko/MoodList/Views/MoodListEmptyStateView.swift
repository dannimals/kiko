import KikoUIKit

class MoodListEmptyStateView: UIView, ViewStylePreparing {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func setupViews() {
        setupImageView()
    }

    private func setupImageView() {
        imageView.image = #imageLiteral(resourceName: "chickPainting")
        imageView.sizeToFit()
        imageView.center = center
        addSubview(imageView)
    }
}

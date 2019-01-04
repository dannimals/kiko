
import KikoUIKit
import UIKit

protocol CreateMoodViewDelegate: class {

    func ringButtonTapped(_ button: UIButton)
    func wavesButtonTapped(_ button: UIButton)
    func logButtonTapped(_ button: UIButton)

}

class CreateMoodView: UIView, ViewStylePreparing, StoryboardNestable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var logButton: RoundedButton!
    @IBOutlet weak var pagingContainerView: UIView!
    @IBOutlet weak var ringButton: UIButton!

    private var animatedWavesView: AnimatedWavesView?

    weak var delegate: CreateMoodViewDelegate!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadViewFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    @IBAction func ringButtonTapped(_ sender: Any) {
        delegate.ringButtonTapped(sender as! UIButton)
    }

    @IBAction func logButtonTapped(_ sender: UIButton) {
        delegate.logButtonTapped(sender)
    }

    func setupViews() {
        setupScrollView()
        setupButtons()
    }

    func updateLogButton(hasMoodForToday: Bool) {
        let logButtonTitle = hasMoodForToday ? Glossary.update.rawValue : Glossary.log.rawValue
        logButton.title = logButtonTitle
    }

    func updateColorsForPage(_ page: MoodPageDisplay) {
        logButton.backgroundColor = page.accessoryColor
        logButton.highlightedBackgroundColor = page.accessoryColor.faded
        gradientView.colors = page.gradientColors
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !scrollView.subviews.contains(where: { $0 is AnimatedWavesView }) {
            let animatedWavesFrame = CGRect(origin: CGPoint(x: bounds.width, y: -layoutMargins.top), size: CGSize(width: bounds.width, height: bounds.height + layoutMargins.top + layoutMargins.bottom))
            animatedWavesView = AnimatedWavesView(frame: animatedWavesFrame)
            scrollView.addSubview(animatedWavesView!)
        }
        scrollView.contentSize = CGSize(width: bounds.width * 2, height: 0)
    }

    private func setupScrollView() {
        scrollView.isDirectionalLockEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
    }

    private func setupButtons() {
        logButton.setTitleColor(.white, for: .normal)
        logButton.backgroundColor = .yellow04
    }

    func setupColors() {
        backgroundColor = .clear
        scrollView.backgroundColor = .clear
        gradientView.backgroundColor = .clear
    }
}

extension CreateMoodView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= bounds.width {
            animatedWavesView?.showFooter()
        }
        if scrollView.contentOffset.x == 0 {
            animatedWavesView?.hideFooter()
        }
    }
}

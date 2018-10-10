
import KikoUIKit

class MoodPagingView: UIView {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagingControl: CustomPagingControl!
    private let moodStackView = UIStackView()
    private var pages: [MoodPageDisplayable] = []
    private weak var delegate: MoodPagingDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func configure(pages: [MoodPageDisplayable], delegate: MoodPagingDelegate) {
        self.pages = pages
        self.delegate = delegate
        updateMoodStackView()
    }

    private func updateMoodStackView() {
        layoutMoodStackView(pageCount: CGFloat(pages.count))
        pages.forEach { moodStackView.addArrangedSubview(imageView($0.image)) }
        func imageView(_ image: UIImage) -> UIImageView {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center
            imageView.bounds = scrollView.bounds
            return imageView
        }
    }

    private func setup() {
        scrollView.delegate = self
        setupLabel()
        setupStackView()
    }

    private func setupStackView() {
        moodStackView.translatesAutoresizingMaskIntoConstraints = false
        moodStackView.contentMode = .scaleAspectFill
        moodStackView.distribution = .fillEqually
        moodStackView.axis = .horizontal
        addSubview(moodStackView)
        scrollView.addSubview(moodStackView)
        moodStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        moodStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        moodStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        moodStackView.heightAnchor.constraint(equalToConstant: scrollView.bounds.height).isActive = true
    }

    private func layoutMoodStackView(pageCount: CGFloat) {
        let width = pageCount * bounds.width
        moodStackView.widthAnchor.constraint(equalToConstant: width).isActive = true
        moodStackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: width, height: scrollView.bounds.height)
    }

    private func setupLabel() {
        let attributedText = NSAttributedString(string: "How are you ", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor: UIColor.cornflowerYellow])
        let mutableString = NSMutableAttributedString(attributedString: attributedText)
        let secondAttributedText = NSAttributedString(string: "today", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .heavy), .foregroundColor: UIColor.cornflowerYellow])
        let thirdAttributedText = NSAttributedString(string: "?", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor: UIColor.cornflowerYellow])
        mutableString.append(secondAttributedText)
        mutableString.append(thirdAttributedText)
        greetingLabel.attributedText = mutableString
        greetingLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

}

extension MoodPagingView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = indexOfCurrentMoodImage()
        guard index < pages.count else { return }
        scrollToSelectedIndex(index)
        delegate.pagingViewDidScroll(self, page: pages[index])
        guard index < pages.count else { return }
        let color = pages[index].accessoryColor
        animateChangeFor(color: color, selectedIndex: index)
    }

    private func scrollToSelectedIndex(_ index: Int) {
        guard index < pages.count else { return }

        let offset = CGPoint(x: bounds.width * CGFloat(index), y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.scrollView.setContentOffset(offset, animated: true)
        })
    }

    private func animateChangeFor(color: UIColor, selectedIndex: Int) {
        UIView.animate(withDuration: 0.4) {
            self.pagingControl.update(selectedIndex: selectedIndex, color: color)
            self.greetingLabel.textColor = color
        }
    }

    private func indexOfCurrentMoodImage() -> Int {
        let offSetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let index = Int(offSetX / width)
        return index
    }

}


import KikoUIKit

class MoodPagingView: UIView, ViewStylePreparing {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pagingControl: CustomPagingControl!

    private let defaultTextColor = UIColor.yellow04
    private let moodStackView = UIStackView()
    private var pages: [MoodPageDisplayable] = []
    private var viewModel: MoodPageViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    func configure(viewModel: MoodPageViewModel) {
        self.pages = viewModel.pages
        self.viewModel = viewModel
        updateMoodStackView()
    }

    private func updateMoodStackView() {
        layoutMoodStackView(pageCount: CGFloat(pages.count))
        pages.forEach {
            
            
            guard let animatedImages = UIImage.animatedImage(with: $0.images, duration: 1.5) else { return }
            moodStackView.addArrangedSubview(createImageView(animatedImages))
        }
        func createImageView(_ image: UIImage) -> UIImageView {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center
            imageView.bounds = scrollView.bounds
            return imageView
        }
    }

    func setupViews() {
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
        let attributedText = NSAttributedString(string: "How are you ", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor: defaultTextColor])
        let mutableString = NSMutableAttributedString(attributedString: attributedText)
        let secondAttributedText = NSAttributedString(string: "today", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .heavy), .foregroundColor: defaultTextColor])
        let thirdAttributedText = NSAttributedString(string: "?", attributes: [.font: UIFont.customFont(ofSize: 24, weight: .light), .foregroundColor: defaultTextColor])
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
        viewModel.updateCurrentPage(pages[index])
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

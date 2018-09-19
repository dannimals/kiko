import KikoModels
import KikoUIKit

struct MoodPageDisplayable {
    let moodType: MoodType
    let image: UIImage
    let primaryColor: UIColor
    let accessoryColor: UIColor
}

protocol MoodPagingDelegate: class {

    func pagingViewDidScroll(_ pagingView: MoodPagingViewController, page: MoodPageDisplayable)
}

class MoodPagingViewController: BaseViewController {

    private weak var delegate: MoodPagingDelegate?
    private var pages: [MoodPageDisplayable] = []
    private let moodStackView = UIStackView()
    private let moodScrollView = UIScrollView()
    private let pageControl = UIPageControl()

    func configure(delegate: MoodPagingDelegate) {
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()
        setupScrollView()
        setupMoodStackView()
        setupPageControl()
    }

    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = pages.first?.accessoryColor
        pageControl.pageIndicatorTintColor = pages.first?.accessoryColor.faded
        pageControl.numberOfPages = pages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: moodScrollView.bottomAnchor, constant: 60).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupScrollView() {
        moodScrollView.isPagingEnabled = true
        moodScrollView.delegate = self
        moodScrollView.alwaysBounceHorizontal = true
        moodScrollView.isDirectionalLockEnabled = true
        moodScrollView.translatesAutoresizingMaskIntoConstraints = false
        moodScrollView.showsVerticalScrollIndicator = false
        moodScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(moodScrollView)
        moodScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        moodScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        moodScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        moodScrollView.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }

    private func setupPages() {
        pages.append(MoodPageDisplayable(moodType: .chick, image: #imageLiteral(resourceName: "chick"), primaryColor: .backgroundYellow, accessoryColor: .cornflowerYellow))
        pages.append(MoodPageDisplayable(moodType: .chickEgg, image: #imageLiteral(resourceName: "chickEgg"), primaryColor: .backgroundPurple, accessoryColor: .tealBlue))
        pages.append(MoodPageDisplayable(moodType: .egg, image: #imageLiteral(resourceName: "egg"), primaryColor: .backgroundRed, accessoryColor: .salmonPink))
        pages.append(MoodPageDisplayable(moodType: .rottenEgg, image: #imageLiteral(resourceName: "rottenEgg"), primaryColor: .backgroundGreen, accessoryColor: .mossGreen))
    }

    private func setupMoodStackView() {
        moodStackView.contentMode = .scaleAspectFill
        moodStackView.distribution = .fillEqually
        moodStackView.axis = .horizontal
        pages.forEach { page in
            let imageView = UIImageView(image: page.image)
            imageView.contentMode = .center
            moodStackView.addArrangedSubview(imageView)
        }
        moodStackView.translatesAutoresizingMaskIntoConstraints = false
        moodScrollView.addSubview(moodStackView)
        moodStackView.centerYAnchor.constraint(equalTo: moodScrollView.centerYAnchor).isActive = true
        moodStackView.leadingAnchor.constraint(equalTo: moodScrollView.leadingAnchor).isActive = true
        moodStackView.widthAnchor.constraint(equalToConstant: 4 * view.bounds.width).isActive = true
        moodStackView.trailingAnchor.constraint(equalTo: moodScrollView.trailingAnchor).isActive = true
        moodScrollView.contentSize = moodStackView.bounds.size
    }
}

extension MoodPagingViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = indexOfCurrentMoodImage()
        guard index < pages.count else { return }

        delegate?.pagingViewDidScroll(self, page: pages[index])
        scrollToSelectedIndex(index)
        updatePageControl(forSelectedIndex: index)
    }

    private func scrollToSelectedIndex(_ index: Int) {
        guard index < pages.count else { return }

        let offset = CGPoint(x: view.bounds.width * CGFloat(index), y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: { [unowned self] in
            self.moodScrollView.setContentOffset(offset, animated: true)
        })
    }

    private func updatePageControl(forSelectedIndex index: Int) {
        guard index < pages.count else { return }

        let page = pages[index]
        UIView.animate(withDuration: 0.4) {
            self.pageControl.currentPage = index
            self.pageControl.currentPageIndicatorTintColor = page.accessoryColor
            self.pageControl.pageIndicatorTintColor = page.accessoryColor.faded
        }
    }

    private func indexOfCurrentMoodImage() -> Int {
        let offSetX = moodScrollView.contentOffset.x
        let width = moodScrollView.bounds.width
        let index = Int(offSetX / width)
        return index
    }

}

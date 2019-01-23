
import KikoModels
import KikoUIKit

protocol MoodPageDisplayable {
    var images: [UIImage] { get }
    var moodType: MoodType { get }
    var accessoryColor: UIColor { get }
}

struct MoodPageDisplay: MoodPageDisplayable {

    var images: [UIImage] = []
    var gradientColors: [CGColor] = []
    let moodType: MoodType
    let accessoryColor: UIColor

    init(type: MoodType) {
        self.moodType = type
        switch type {
        case .chick:
            accessoryColor = .yellow04
            images = [#imageLiteral(resourceName: "chick")]
            gradientColors = [UIColor.yellow01.cgColor, UIColor.yellow02.cgColor, UIColor.yellow03.cgColor]
        case .chickEgg:
            accessoryColor = .blue04
            images = [#imageLiteral(resourceName: "chickEgg")]
            gradientColors = [UIColor.blue01.cgColor, UIColor.blue02.cgColor, UIColor.blue03.cgColor]
        case .egg:
            accessoryColor = .red04
            images = [#imageLiteral(resourceName: "egg")]
            gradientColors = [UIColor.red01.cgColor, UIColor.red02.cgColor, UIColor.red03.cgColor]
        case .rottenEgg:
            accessoryColor = .green04
            images = [#imageLiteral(resourceName: "rottenEgg2")]
            gradientColors = [UIColor.green01.cgColor, UIColor.green02.cgColor, UIColor.green03.cgColor]
        }
    }

    private func images(forPrefix prefix: String, totalCount: Int) -> [UIImage] {
        return Array(1...totalCount).compactMap { index in
            let imageName = "\(prefix)\(index)"
            return UIImage(named: imageName)
        }
    }
}

protocol MoodPagingDelegate: class {

    func pagingViewDidScroll(_ pagingView: MoodPagingView, page: MoodPageDisplayable)
}

class PagingViewController: BaseViewController, StoryboardLoadable {

    @IBOutlet weak var contentView: MoodPagingView!
    private var viewModel: MoodPageViewModel?

    func configure(viewModel: MoodPageViewModel, observer: MoodPagingObserving) {
        self.viewModel = viewModel
        contentView.configure(viewModel: viewModel)
        viewModel.addObserver(observer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = CGFloat(viewModel?.pages.count ?? 0) * view.bounds.width
        contentView.scrollView.contentSize = CGSize(width: width, height: contentView.scrollView.bounds.height)
    }

}
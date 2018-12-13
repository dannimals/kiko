
import KikoModels
import KikoUIKit

protocol MoodPageDisplayable {
    var images: [UIImage] { get }
    var moodType: MoodType { get }
    var primaryColor: UIColor { get }
    var accessoryColor: UIColor { get }
    var selectedColor: UIColor { get }
}

struct MoodPageDisplay: MoodPageDisplayable {

    var images: [UIImage] = []
    let moodType: MoodType
    let primaryColor: UIColor
    let accessoryColor: UIColor
    let selectedColor: UIColor

    init(type: MoodType) {
        self.moodType = type
        switch type {
        case .chick:
            primaryColor = .backgroundYellow
            accessoryColor = .cornflowerYellow
            selectedColor = .selectedSalmonPink
            images = images(forPrefix: ImageName.chick, totalCount: 2)
        case .chickEgg:
            primaryColor = .backgroundPurple
            accessoryColor = .tealBlue
            selectedColor = .selectedTeal
            images = images(forPrefix: ImageName.chickEgg, totalCount: 4)
        case .egg:
            primaryColor = .backgroundRed
            accessoryColor = .salmonPink
            selectedColor = .selectedRouge
            images = images(forPrefix: ImageName.egg, totalCount: 2)
        case .rottenEgg:
            primaryColor = .backgroundGreen
            accessoryColor = .mossGreen
            selectedColor = .selectedGreen
            images = images(forPrefix: ImageName.rottenEgg, totalCount: 2)
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

class PagingViewController: BaseViewController {

    private let pagingView: MoodPagingView = MoodPagingView.loadFromNib()

    func configure(viewModel: MoodPageViewModel, observer: MoodPagingObserving) {
        pagingView.configure(viewModel: viewModel)
        viewModel.addObserver(observer)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    private func configureViews() {
        view.addSubview(pagingView)
        pagingView.stretchToFill()
        pagingView.layoutIfNeeded()
    }

}

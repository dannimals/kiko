
import KikoModels
import KikoUIKit

struct MoodPageDisplayable {
    let moodType: MoodType
    let image: UIImage
    let primaryColor: UIColor
    let accessoryColor: UIColor
    let selectedColor: UIColor

    init(type: MoodType) {
        self.moodType = type
        switch type {
        case .chick:
            image = #imageLiteral(resourceName: "chick")
            primaryColor = .backgroundYellow
            accessoryColor = .cornflowerYellow
            selectedColor = .selectedSalmonPink
        case .chickEgg:
            image = #imageLiteral(resourceName: "chickEgg")
            primaryColor = .backgroundPurple
            accessoryColor = .tealBlue
            selectedColor = .selectedTeal
        case .egg:
            image = #imageLiteral(resourceName: "egg")
            primaryColor = .backgroundRed
            accessoryColor = .salmonPink
            selectedColor = .selectedRouge
        case .rottenEgg:
            image = #imageLiteral(resourceName: "rottenEgg")
            primaryColor = .backgroundGreen
            accessoryColor = .mossGreen
            selectedColor = .selectedGreen
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

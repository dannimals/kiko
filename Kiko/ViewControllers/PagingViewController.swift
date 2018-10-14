import KikoModels
import KikoUIKit

struct MoodPageDisplayable {
    let moodType: MoodType
    let image: UIImage
    let primaryColor: UIColor
    let accessoryColor: UIColor
    let selectedColor: UIColor
}

protocol MoodPagingDelegate: class {

    func pagingViewDidScroll(_ pagingView: MoodPagingView, page: MoodPageDisplayable)
}

class PagingViewController: BaseViewController {

    private let pagingView: MoodPagingView = MoodPagingView.loadFromNib()

    func configure(delegate: MoodPagingDelegate, viewModel: MoodPageViewModel) {
        pagingView.configure(pages: viewModel.pages, delegate: delegate)
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

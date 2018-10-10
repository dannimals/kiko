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

    private weak var delegate: MoodPagingDelegate!
    private var moodPagingView: MoodPagingView = MoodPagingView.loadFromNib()
    private var viewModel: MoodPageViewModel?

    func configure(delegate: MoodPagingDelegate, viewModel: MoodPageViewModel) {
        self.delegate = delegate
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        moodPagingView.configure(pages: viewModel!.pages, delegate: delegate)
        view.layoutIfNeeded()
    }

    private func configureViews() {
        moodPagingView.stretchToFill(parentView: view)
        moodPagingView.layoutIfNeeded()
    }

}


import KikoUIKit
import KikoModels

class MoodListViewController: BaseViewController {
    private let viewModel: MoodListViewModel
    private let emptyStateView = UIView()

    required init(viewModel: MoodListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
        setupEmptyStateView()
        view.backgroundColor = .paleBlue
    }

    private func configureBackButton() {
        let backButton = TappableButton()
        let image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.backgroundBlue
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        let frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height)
        emptyStateView.frame = frame
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chickPainting")
        imageView.sizeToFit()
        imageView.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        emptyStateView.addSubview(imageView)

        let logButton = UIButton()
        logButton.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(logButton)
        logButton.layer.cornerRadius = 16
        logButton.backgroundColor = UIColor.backgroundBlue
        logButton.titleLabel?.font = UIFont.customFont(ofSize: 17, weight: .heavy)
        logButton.setTitle("Log a Mood", for: .normal)
        NSLayoutConstraint.activate([
            logButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            logButton.heightAnchor.constraint(equalToConstant: 32),
            logButton.widthAnchor.constraint(equalToConstant: 135),
            logButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35)
            ])
        logButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() { navigationController?.popViewController(animated: true) }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

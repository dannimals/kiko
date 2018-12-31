import KikoUIKit

class AnimatedWavesViewController: BaseViewController {

    var contentView: AnimatedWavesView!

    override func loadView() {
        super.loadView()

        contentView = AnimatedWavesView(frame: view.frame)
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackButton()
    }

    private func configureBackButton() {
        let backButton = TappableButton()
        let image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.paleBlue
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() { navigationController?.popViewController(animated: true)
    }

    deinit {
        contentView.reset()
    }
}

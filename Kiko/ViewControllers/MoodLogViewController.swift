
import KikoUIKit

class MoodLogViewController: BaseViewController {
    let ringButton = UIButton()
    let wavesButton = UIButton()
    let calendarWeekView: CalendarWeekView = CalendarWeekView.loadFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    private func configure() {
        view.backgroundColor = .backgroundYellow

        ringButton.setImage(#imageLiteral(resourceName: "moodRing"), for: .normal)
        ringButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ringButton)
        ringButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        ringButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true

        wavesButton.setImage(#imageLiteral(resourceName: "waves"), for: .normal)
        wavesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wavesButton)
        wavesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        wavesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true

        calendarWeekView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarWeekView)
        NSLayoutConstraint.activate([
            calendarWeekView.topAnchor.constraint(equalTo: ringButton.bottomAnchor, constant: 24),
            calendarWeekView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarWeekView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

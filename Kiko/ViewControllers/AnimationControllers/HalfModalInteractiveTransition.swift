
import KikoUIKit

class HalfModalInteractiveTransition: UIPercentDrivenInteractiveTransition {

    var presentingViewController: UIViewController
    var shouldComplete: Bool = false
    let panGestureRecognizer = UIPanGestureRecognizer()

    init(presentingViewController: UIViewController, withView view: UIView) {
        self.presentingViewController = presentingViewController

        super.init()

        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view?.superview)

        switch sender.state {
        case .began:
            self.presentingViewController.dismiss(animated: true, completion: nil)
        case .changed:
            let screenHeight = UIScreen.main.bounds.size.height - 50
            let dragAmount = screenHeight
            let threshold: Float = 0.2
            var percent: Float = Float(translation.y) / Float(dragAmount)

            percent = fmaxf(percent, 0.0)
            percent = fminf(percent, 1.0)

            update(CGFloat(percent))
            shouldComplete = percent > threshold
        case .ended, .cancelled:
            if sender.state == .cancelled || !shouldComplete {
                cancel()
            } else {
                finish()
            }
        default:
            cancel()
        }
    }

}

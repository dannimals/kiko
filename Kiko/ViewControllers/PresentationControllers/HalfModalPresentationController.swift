
import KikoUIKit

enum ModalScaleState {
    case adjustedOnce
    case normal
}

class HalfModalPresentationController: UIPresentationController {
    enum PanDirection {
        case upward
        case none
        case downward
    }

    lazy var dimmingView: UIView? = {
        guard let containerView = containerView else { return nil }

        let dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = dimmingView.bounds
        dimmingView.addSubview(blurEffectView)

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = dimmingView.bounds
        blurEffectView.contentView.addSubview(vibrancyEffectView)

        let tapToDismissRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss(_:)))
        dimmingView.addGestureRecognizer(tapToDismissRecognizer)

        return dimmingView
    }()

    var isPresentedViewFullScreen = false
    var presentedViewPanGesture = UIPanGestureRecognizer()

    private var modalScaleState: ModalScaleState = .normal
    private var panDirection: PanDirection = .none

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupPresentedViewPanGesture()
    }

    private func setupPresentedViewPanGesture() {
        presentedViewPanGesture.addTarget(self, action: #selector(handlePresentedViewPan(_:)))
        presentedViewController.view.addGestureRecognizer(presentedViewPanGesture)
    }

    @objc
    private func handlePresentedViewPan(_ sender: UIPanGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
        let touchPoint = sender.translation(in: sender.view?.superview)

        switch sender.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = sender.velocity(in: sender.view?.superview)
            updateModalScaleForTouchPoint(touchPoint)
            panDirection = panDirectionForVelocity(velocity)
        case .ended:
            updateScaleForPanDirection(panDirection)
        default:
            break
        }
    }

    func changeModalScaleState(to state: ModalScaleState) {
        guard let presentedView = presentedView, let containerView = self.containerView else { return }

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height / 2),
                                       size: CGSize(width: containerFrame.width, height: containerFrame.height / 2))
                let frame = state == .adjustedOnce ? containerView.frame : halfFrame
                presentedView.frame = frame

                if let navController = self.presentedViewController as? UINavigationController {
                    self.isPresentedViewFullScreen = true

                    navController.setNeedsStatusBarAppearanceUpdate()
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: { _ in self.modalScaleState = state })
    }

    private func panDirectionForVelocity(_ velocity: CGPoint) -> PanDirection {
        guard velocity.y != 0 else { return .none }

        let direction: PanDirection = velocity.y > 0 ? .downward : .upward
        return direction
    }

    private func updateScaleForPanDirection(_ direction: PanDirection) {
        if direction == .upward {
            changeModalScaleState(to: .adjustedOnce)
        } else {
            if modalScaleState == .adjustedOnce {
                changeModalScaleState(to: .normal)
            } else {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func updateModalScaleForTouchPoint(_ touchPoint: CGPoint) {
        switch modalScaleState {
        case .adjustedOnce:
            presentedView!.frame.origin.y = touchPoint.y
        case .normal:
            presentedView!.frame.origin.y = touchPoint.y + containerView!.frame.height / 2
        }
    }

    @objc
    private func handleTapToDismiss(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }

        return CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
            let dimmingView = dimmingView,
            let transitionCoordinator = presentingViewController.transitionCoordinator else { return }

        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.addSubview(presentedViewController.view)

        transitionCoordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator,
        let dimmingView = dimmingView else { return }

        transitionCoordinator.animate(alongsideTransition: { _ in
            dimmingView.alpha = 0
            self.presentingViewController.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        isPresentedViewFullScreen = false
    }

}

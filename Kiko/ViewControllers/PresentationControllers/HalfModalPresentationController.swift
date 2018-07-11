
import KikoUIKit

enum ModalScaleState {
    case fullScreen
    case halfScreen
}

class HalfModalPresentationController : UIPresentationController {

    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var direction: CGFloat = 0
    private var state: ModalScaleState = .halfScreen

    private lazy var safeBottomInset: CGFloat = {
        return presentingViewController.view.safeAreaInsets.bottom
    }()

    private lazy var halfContainerViewFrame: CGRect = {
        guard let containerFrame = containerView?.frame else { return CGRect.zero }
        let halfFrame = CGRect(origin: CGPoint(x: 0, y: (containerFrame.height + safeBottomInset) / 2),
                               size: CGSize(width: containerFrame.width, height: (containerFrame.height + safeBottomInset) / 2))
        return halfFrame
    }()

    private lazy var fullContainerViewFrame: CGRect = {
        guard let containerFrame = containerView?.frame else { return CGRect.zero }
        let frame = CGRect(origin: containerFrame.origin,
                               size: CGSize(width: containerFrame.width, height: containerFrame.height + safeBottomInset))
        return frame
    }()

    private lazy var blurView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds

        return view
    }()

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let presentedView = presentedView,
            let containerView = containerView else { return }

        let touchPoint = sender.translation(in: sender.view?.superview)

        switch sender.state {
        case .began:
            presentedView.frame.size.height = containerView.frame.height
        case .changed:
            let velocity = sender.velocity(in: sender.view?.superview)
            switch state {
            case .halfScreen:
                presentedView.frame.origin.y = touchPoint.y + containerView.frame.height / 2
            case .fullScreen:
                presentedView.frame.origin.y = touchPoint.y
            }
            direction = velocity.y
        case .ended:
            if direction < 0 {
                updateModalForState(.fullScreen)
            } else {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }

    private func updateModalForState(_ state: ModalScaleState) {
        guard let presentedView = presentedView else { return }

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
            let frame = state == .fullScreen ? self.fullContainerViewFrame : self.halfContainerViewFrame
            presentedView.frame = frame
        }, completion: { _ in
            self.state = state
        })
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return halfContainerViewFrame
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView,
            let coordinator = presentingViewController.transitionCoordinator else { return }

        blurView.alpha = 0
        containerView.addSubview(blurView)
        containerView.addSubview(presentedViewController.view)

        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.blurView.alpha = 1
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }

        coordinator.animate(alongsideTransition: { context in
            self.blurView.alpha = 0
            self.presentingViewController.view.transform = CGAffineTransform.identity
        }) { _ in self.blurView.removeFromSuperview() }
    }
}

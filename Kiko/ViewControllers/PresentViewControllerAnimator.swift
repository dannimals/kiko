
import KikoUIKit

class PresentViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        let screenBounds = UIScreen.main.bounds

        containerView.insertSubview(toView, aboveSubview: fromView)
        toView.frame.origin = CGPoint(x: 0, y: screenBounds.height)
        toView.frame.size = screenBounds.size
        guard let snapshot = fromView.snapshotView(afterScreenUpdates: false) else { return }
        containerView.insertSubview(snapshot, belowSubview: toView)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                        animations: {
            toView.frame.origin = CGPoint.zero
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled) }
        )
    }
}

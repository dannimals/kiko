
import KikoUIKit

class HalfModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case present
        case dismiss
    }

    var transitionTime: TimeInterval
    var transitionType: TransitionType

    init(transitionTime: TimeInterval, transitionType: TransitionType) {
        self.transitionTime = transitionTime
        self.transitionType = transitionType
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionTime
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame.origin.y = 800
        }) { completed in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

}

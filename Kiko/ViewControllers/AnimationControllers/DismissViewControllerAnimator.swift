
import KikoUIKit

class DismissViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let transitionDuration = 0.6
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }

        let containerView = transitionContext.containerView
        let screenBounds = UIScreen.main.bounds

        containerView.insertSubview(toView, belowSubview: fromView)
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

}

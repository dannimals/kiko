
import KikoUIKit

class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var presentingViewController: UIViewController
    var interactionController: HalfModalInteractiveTransition

    init(presentingViewController: UIViewController, presentedViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.interactionController = HalfModalInteractiveTransition(presentingViewController: presentingViewController, withView: self.presentingViewController.view)

        super.init()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalTransitionAnimator(transitionTime: 0.4, transitionType: .dismiss)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}

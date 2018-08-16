import KikoUIKit

protocol UIViewControllerAlertable where Self: UIViewController {
    func presentModalForSuccess(withImage image: UIImage, imageColor: UIColor)
    func presentModalForFailure(withError error: Error, message: String)
}

extension UIViewController: UIViewControllerAlertable {
    func presentModalForSuccess(withImage image: UIImage = #imageLiteral(resourceName: "splatter"), imageColor: UIColor) {
        let completionStateViewController: MoodLogCompletionStateViewController = MoodLogCompletionStateViewController.loadFromNib()
        completionStateViewController.configure(withImage: image, imageColor: imageColor)
        completionStateViewController.modalPresentationStyle = .overCurrentContext
        present(completionStateViewController, animated: true, completion: { () -> Void in
            let delayTime = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    func presentModalForFailure(withError error: Error, message: String) {

    }

}

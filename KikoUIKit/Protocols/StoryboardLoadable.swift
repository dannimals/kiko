
import UIKit

public protocol StoryboardLoadable {

    static func initFromStoryboard(_ storyboardName: String) -> Self

}

public extension StoryboardLoadable where Self: UIViewController {

    static func initFromStoryboard(_ storyboardName: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }

}

import UIKit


public extension UIViewControllerTransitionCoordinator {

	public func animateAlongsideTransition(animation: (UIViewControllerTransitionCoordinatorContext -> Void)?) -> Bool {
		return animateAlongsideTransition(animation, completion: nil)
	}


	public func animateAlongsideTransitionInView(view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool {
		return animateAlongsideTransitionInView(view, animation: animation, completion: nil)
	}
}

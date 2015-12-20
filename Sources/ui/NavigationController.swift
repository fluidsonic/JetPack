import UIKit


public /* non-final */ class NavigationController: UINavigationController {

	public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
		return topViewController?.preferredInterfaceOrientationForPresentation() ?? .Portrait
	}


	public override func shouldAutorotate() -> Bool {
		return topViewController?.shouldAutorotate() ?? false
	}


	public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		guard let topViewController = self.topViewController else {
			switch UIDevice.currentDevice().userInterfaceIdiom {
			case .Pad:         return .All
			case .Phone:       return .AllButUpsideDown
			case .TV:          return .All
			case .Unspecified: return .All
			}
		}

		return topViewController.supportedInterfaceOrientations()
	}
}

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

			default: // add `case .CarPlay` & `case .Unspecified` as soon as Xcode 7.3 goes out of beta
				return .All
			}
		}

		return topViewController.supportedInterfaceOrientations()
	}
}

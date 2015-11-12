import Foundation
import UIKit


public extension NSBundle {

	private static var onceToken = dispatch_once_t()


	@objc
	public override class func initialize() {
		dispatch_once(&onceToken) {
			Keyboard.setUp()
			UITableViewCell.UITableViewCell_setUp()
			UITextField.UITextField_setUp()
			UIViewController.UIViewController_setUp()
			UINavigationController.UINavigationController_setUp()
		}
	}
}

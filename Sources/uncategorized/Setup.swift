import Foundation
import UIKit


public extension NSBundle {

	private static var onceToken = dispatch_once_t()


	@objc
	public override class func initialize() {
		dispatch_once(&onceToken) {
			Keyboard.setUp()
			UIViewController.setUp()
		}
	}
}

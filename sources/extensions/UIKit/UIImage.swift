import UIKit


public extension UIImage {

	public var hasAlphaChannel: Bool {
		let info = CGImageGetAlphaInfo(CGImage)
		switch info {
		case .First, .Last, .Only, .PremultipliedFirst, .PremultipliedLast:
			return true

		case .None, .NoneSkipFirst, .NoneSkipLast:
			return false
		}
	}


	public static func templateNamed(name: String) -> UIImage? {
		return self.init(named: name)?.imageWithRenderingMode(.AlwaysTemplate)
	}
}
import Foundation


public extension NSAttributedString {

	static func build(_ build: (_ builder: NSMutableAttributedString) -> Void) -> NSAttributedString {
		let builder = NSMutableAttributedString()
		build(builder)
		return builder
	}
}


public extension NSObjectProtocol where Self: NSAttributedString {

	@nonobjc
	var nonEmpty: Self? {
		if string.isEmpty {
			return nil
		}

		return self
	}
}

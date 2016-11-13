import Foundation


public extension NSObjectProtocol where Self: NSAttributedString {

	@nonobjc
	public var nonEmpty: Self? {
		if string.isEmpty {
			return nil
		}

		return self
	}
}

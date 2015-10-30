import Foundation


public extension ErrorType {

	@nonobjc
	public var originalNSError: NSError? {
		return self as? NSObject as? NSError // force Swift to use the original NSError instance instead of synthesizing a new one which would drop the userInfo dictionary and subclass
	}
}

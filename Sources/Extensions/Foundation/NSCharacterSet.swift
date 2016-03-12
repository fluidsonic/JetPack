import Foundation


public extension NSCharacterSet {

	@nonobjc
	private static let _URLPathComponentAllowedCharacterSet: NSCharacterSet = {
		let characterSet = NSMutableCharacterSet()
		characterSet.formUnionWithCharacterSet(NSCharacterSet.URLPathAllowedCharacterSet())
		characterSet.removeCharactersInString("/")

		return characterSet.copy() as! NSCharacterSet
	}()


	@nonobjc
	private static let _URLQueryParameterAllowedCharacterSet: NSCharacterSet = {
		let characterSet = NSMutableCharacterSet()
		characterSet.formUnionWithCharacterSet(NSCharacterSet.URLQueryAllowedCharacterSet())
		characterSet.removeCharactersInString("+&=")

		return characterSet.copy() as! NSCharacterSet
	}()


	@nonobjc
	@warn_unused_result
	public static func URLPathComponentAllowedCharacterSet() -> NSCharacterSet {
		return _URLPathComponentAllowedCharacterSet
	}


	@nonobjc
	@warn_unused_result
	public static func URLQueryParameterAllowedCharacterSet() -> NSCharacterSet {
		return _URLQueryParameterAllowedCharacterSet
	}
}

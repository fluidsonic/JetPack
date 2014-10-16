import Foundation


extension NSCharacterSet {

	class func URLPathComponentAllowedCharacterSet() -> NSCharacterSet {
		struct Static {
			static let value: NSCharacterSet = {
				let set = NSMutableCharacterSet()
				set.formUnionWithCharacterSet(NSCharacterSet.URLPathAllowedCharacterSet())  // TODO use 'self' instead of NSCharacterSet once it no longer crashes the compiler - or private globals once the symbols no longer collide across files
				set.removeCharactersInString("/")

				return set
				}()
		}

		return Static.value
	}

	class func URLQueryParameterAllowedCharacterSet() -> NSCharacterSet {
		struct Static {
			static let value: NSCharacterSet = {
				let set = NSMutableCharacterSet()
				set.formUnionWithCharacterSet(NSCharacterSet.URLQueryAllowedCharacterSet())  // TODO use 'self' instead of NSCharacterSet once it no longer crashes the compiler - or private globals once the symbols no longer collide across files
				set.removeCharactersInString("+&=")

				return set
				}()
		}

		return Static.value
	}
}

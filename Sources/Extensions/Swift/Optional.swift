// Allows extension for Optional depending on the wrapped type.

public protocol _Optional: ExpressibleByNilLiteral {

	associatedtype Wrapped

	init(_ some: Wrapped)


	func flatMap<U> (_ transform: (Wrapped) throws -> U?) rethrows -> U?
	func map<U>     (_ transform: (Wrapped) throws -> U) rethrows -> U?
}


extension Optional: _Optional {}


internal extension _Optional {

	internal var value: Wrapped? {
		return map { $0 }
	}
}

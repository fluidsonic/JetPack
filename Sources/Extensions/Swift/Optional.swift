// Allows extension for Optional depending on the wrapped type.

public protocol _Optional: NilLiteralConvertible {

	associatedtype Wrapped

	init()
	init(_ some: Wrapped)

	@warn_unused_result
	func map<U>(@noescape f: (Wrapped) throws -> U) rethrows -> U?

	@warn_unused_result
	func flatMap<U>(@noescape f: (Wrapped) throws -> U?) rethrows -> U?
}


extension Optional: _Optional {}


internal extension _Optional {

	internal var value: Wrapped? {
		return map { $0 }
	}
}

// _Optional allows extending extending of Optional depending on the wrapped type.

public protocol _Optional: ExpressibleByNilLiteral {

	associatedtype Wrapped

	init(_ some: Wrapped)

	func flatMap<U> (_ transform: (Wrapped) throws -> U?) rethrows -> U?
	func map<U>     (_ transform: (Wrapped) throws -> U) rethrows -> U?
}


extension _Optional {

	internal var value: Wrapped? {
		return map { $0 }
	}
}

extension Optional: _Optional {}



internal protocol _TypeerasedOptional {

	var typeerasedSelf: Any? { get }
}


extension Optional: _TypeerasedOptional {

	internal var typeerasedSelf: Any? {
		guard let value = self else {
			return nil
		}

		return value
	}
}

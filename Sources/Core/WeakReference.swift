public final class WeakReference<Value : AnyObject> {

	public weak var value: Value?


	public init() {}


	public init(_ value: Value) {
		self.value = value
	}
}


extension WeakReference: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "WeakReference(\(String(reflecting: value)))"
	}
}


extension WeakReference: CustomStringConvertible {

	public var description: String {
		return String(describing: value)
	}
}

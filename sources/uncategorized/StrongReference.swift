public class StrongReference<T> {

	public var target: T?


	public init() {}
	public init(_ target: T) { self.target = target }
}

public class WeakReference<T : AnyObject> {

	public weak var target: T?


	public init() {}
	public init(_ target: T) { self.target = target }
}

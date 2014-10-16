class WeakReference<T : AnyObject> {

	weak var target: T?


	init() {}
	init(_ target: T) { self.target = target }
}

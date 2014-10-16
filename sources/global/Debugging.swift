public func pointerOf(object: AnyObject) -> COpaquePointer {
	return Unmanaged<AnyObject>.passUnretained(object).toOpaque()
}

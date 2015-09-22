public typealias Closure = () -> ()
public typealias CancelClosure = Closure!  // temporary workaround for cancellation via closure until we have a nice struct instead

@available(*, unavailable, renamed="Closure")
public typealias Block = Closure

@available(*, unavailable, renamed="CancelClosure")
public typealias CancelBlock = CancelClosure

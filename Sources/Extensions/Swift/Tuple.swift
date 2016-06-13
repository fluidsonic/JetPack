@warn_unused_result
public func ==(lhs: (), rhs: ()) -> Bool {
	return true
}


@warn_unused_result
public func !=(lhs: (), rhs: ()) -> Bool {
	return false
}


@warn_unused_result
public func == <A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}


@warn_unused_result
public func != <A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}


@warn_unused_result
public func == <A: Equatable, B: Equatable>(lhs: (A?, B), rhs: (A?, B)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}


@warn_unused_result
public func != <A: Equatable, B: Equatable>(lhs: (A?, B), rhs: (A?, B)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}


@warn_unused_result
public func == <A: Equatable, B: Equatable>(lhs: (A, B?), rhs: (A, B?)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}


@warn_unused_result
public func != <A: Equatable, B: Equatable>(lhs: (A, B?), rhs: (A, B?)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}


public func ==(lhs: (), rhs: ()) -> Bool {
	return true
}



public func !=(lhs: (), rhs: ()) -> Bool {
	return false
}



public func == <A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}



public func != <A: Equatable, B: Equatable>(lhs: (A?, B?), rhs: (A?, B?)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}



public func == <A: Equatable, B: Equatable>(lhs: (A?, B), rhs: (A?, B)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}



public func != <A: Equatable, B: Equatable>(lhs: (A?, B), rhs: (A?, B)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}



public func == <A: Equatable, B: Equatable>(lhs: (A, B?), rhs: (A, B?)) -> Bool {
	return lhs.0 == rhs.0 && lhs.1 == rhs.1
}



public func != <A: Equatable, B: Equatable>(lhs: (A, B?), rhs: (A, B?)) -> Bool {
	return lhs.0 != rhs.0 || lhs.1 != rhs.1
}

import XCTest


internal final class EmptyEqualObject: Hashable {

	internal init() {}


	internal var hashValue: Int {
		return 0
	}
}


internal final class EmptyNonEqualObject: Hashable {

	internal init() {}


	internal var hashValue: Int {
		return ObjectIdentifier(self).hashValue
	}
}


internal func == (a: EmptyEqualObject, b: EmptyEqualObject) -> Bool {
	return true
}


internal func == (a: EmptyNonEqualObject, b: EmptyNonEqualObject) -> Bool {
	return a === b
}



internal func XCTAssertEqual<X: Equatable, Y: Equatable> (expression1: (X, Y)?, _ expression2: (X, Y)?) {
	if let expression1 = expression1, expression2 = expression2 {
		XCTAssertTrue(expression1.0 == expression2.0 && expression1.1 == expression2.1)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil)
}


internal func XCTAssertEqual<X: Equatable, Y: Equatable> (expression1: [(X, Y)]?, _ expression2: [(X, Y)]?) {
	if let expression1 = expression1, expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count)

		for index in 0 ..< expression1.count {
			XCTAssertEqual(expression1[index], expression2[index])
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil)
}


internal func XCTAssertEqual<T: Equatable> (expression1: [T]?, _ expression2: [T]?) {
	if let expression1 = expression1, expression2 = expression2 {
		XCTAssertEqual(expression1, expression2)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil)
}


internal func XCTAssertIdentical<T: AnyObject> (expression1: T?, _ expression2: T?) {
	XCTAssertTrue(expression1 === expression2)
}


internal func XCTAssertIdentical<T: AnyObject> (expression1: [T]?, _ expression2: [T]?) {
	if let expression1 = expression1, expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count)

		for index in 0 ..< expression1.count {
			XCTAssertIdentical(expression1[index], expression2[index])
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil)
}


internal func XCTAssertIdentical<T where T: AnyObject, T: Hashable> (expression1: Set<T>?, _ expression2: Set<T>?) {
	if let expression1 = expression1, expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count)

		for (element1, element2) in zip(expression1, expression2) {
			XCTAssertIdentical(element1, element2)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil)
}

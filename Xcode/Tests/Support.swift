import JetPack
import XCTest


internal struct EmptyStruct {}


internal final class EmptyEqualObject: CustomStringConvertible, Hashable {

	internal init() {}


	internal var description: String {
		return "EmptyEqualObject(\(pointer(of: self)))"
	}


	internal var hashValue: Int {
		return 0
	}
}


internal final class EmptyNonEqualObject: CustomStringConvertible, Hashable {

	internal init() {}


	internal var description: String {
		return "EmptyNonEqualObject(\(pointer(of: self)))"
	}


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



internal func XCTAssertEqual<X: Equatable, Y: Equatable> (_ expression1: (X, Y)?, _ expression2: (X, Y)?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertTrue(expression1.0 == expression2.0 && expression1.1 == expression2.1, file: file, line: line)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


internal func XCTAssertEqual<X: Equatable, Y: Equatable> (_ expression1: [(X, Y)]?, _ expression2: [(X, Y)]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for index in 0 ..< expression1.count {
			XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


internal func XCTAssertEqual<T: Equatable> (_ expression1: [T]?, _ expression2: [T]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1, expression2, file: file, line: line)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


internal func XCTAssertEqual<T: Equatable> (_ expression1: [T?], _ expression2: [T?], file: StaticString = #file, line: UInt = #line) {
	XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
	for index in 0 ..< expression1.count {
		XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
	}
}


internal func XCTAssertEqual<T: Equatable> (_ expression1: [T?]?, _ expression2: [T?]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
		for index in 0 ..< expression1.count {
			XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


internal func XCTAssertIdentical<T: AnyObject> (_ expression1: T?, _ expression2: T?, file: StaticString = #file, line: UInt = #line) {
	XCTAssertTrue(expression1 === expression2, "\(String(describing: expression1)) is not identical to \(String(describing: expression2))", file: file, line: line)
}


internal func XCTAssertIdentical<T: AnyObject> (_ expression1: [T]?, _ expression2: [T]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for index in 0 ..< expression1.count {
			XCTAssertIdentical(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


internal func XCTAssertIdentical<T: AnyObject> (_ expression1: Set<T>?, _ expression2: Set<T>?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for (element1, element2) in zip(expression1, expression2) {
			XCTAssertIdentical(element1, element2, file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}

import JetPack
import XCTest


struct EmptyStruct {}


final class EmptyEqualObject: CustomStringConvertible, Hashable {

	init() {}


	var description: String {
		return "EmptyEqualObject(\(pointer(of: self)))"
	}


	func hash(into hasher: inout Hasher) {}
}


final class EmptyNonEqualObject: CustomStringConvertible, Hashable {

	init() {}


	var description: String {
		return "EmptyNonEqualObject(\(pointer(of: self)))"
	}


	func hash(into hasher: inout Hasher) {
		hasher.combine(ObjectIdentifier(self))
	}
}


func == (a: EmptyEqualObject, b: EmptyEqualObject) -> Bool {
	return true
}


func == (a: EmptyNonEqualObject, b: EmptyNonEqualObject) -> Bool {
	return a === b
}



func XCTAssertEqual<X: Equatable, Y: Equatable> (_ expression1: (X, Y)?, _ expression2: (X, Y)?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertTrue(expression1.0 == expression2.0 && expression1.1 == expression2.1, file: file, line: line)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertEqual<X: Equatable, Y: Equatable> (_ expression1: [(X, Y)]?, _ expression2: [(X, Y)]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for index in 0 ..< expression1.count {
			XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertEqual<T: Equatable> (_ expression1: [T]?, _ expression2: [T]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1, expression2, file: file, line: line)
		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertEqual<T: Equatable> (_ expression1: [T?], _ expression2: [T?], file: StaticString = #file, line: UInt = #line) {
	XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
	for index in 0 ..< expression1.count {
		XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
	}
}


func XCTAssertEqual<T: Equatable> (_ expression1: [T?]?, _ expression2: [T?]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)
		for index in 0 ..< expression1.count {
			XCTAssertEqual(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertIdentical<T: AnyObject> (_ expression1: T?, _ expression2: T?, file: StaticString = #file, line: UInt = #line) {
	XCTAssertTrue(expression1 === expression2, "\(String(describing: expression1)) is not identical to \(String(describing: expression2))", file: file, line: line)
}


func XCTAssertIdentical<T: AnyObject> (_ expression1: [T]?, _ expression2: [T]?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for index in 0 ..< expression1.count {
			XCTAssertIdentical(expression1[index], expression2[index], file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertIdentical<T: AnyObject> (_ expression1: Set<T>?, _ expression2: Set<T>?, file: StaticString = #file, line: UInt = #line) {
	if let expression1 = expression1, let expression2 = expression2 {
		XCTAssertEqual(expression1.count, expression2.count, file: file, line: line)

		for (element1, element2) in zip(expression1, expression2) {
			XCTAssertIdentical(element1, element2, file: file, line: line)
		}

		return
	}

	XCTAssertTrue(expression1 == nil && expression2 == nil, file: file, line: line)
}


func XCTAssertEqual(_ expression1: CGRect, _ expression2: CGRect, accuracy: CGFloat, file: StaticString = #file, line: UInt = #line) {
	XCTAssertEqual(expression1.origin.x, expression2.origin.x, accuracy: accuracy, file: file, line: line)
	XCTAssertEqual(expression1.origin.y, expression2.origin.y, accuracy: accuracy, file: file, line: line)
	XCTAssertEqual(expression1.width,    expression2.width,    accuracy: accuracy, file: file, line: line)
	XCTAssertEqual(expression1.height,   expression2.height,   accuracy: accuracy, file: file, line: line)
}

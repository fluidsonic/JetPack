import Foundation


public extension NSRange {

	@nonobjc
	public init(forString string: String) {
		let indices = string.characters.indices

		self.init(range: indices.startIndex ..< indices.endIndex, inString: string)
	}


	@nonobjc
	public init(range: Range<String.Index>?, inString string: String) {
		if let range = range {
			let location = NSRange.locationForIndex(range.lowerBound, inString: string)
			let endLocation = NSRange.locationForIndex(range.upperBound, inString: string)

			self.init(location: location, length: location.distance(to: endLocation))
		}
		else {
			self.init(location: NSNotFound, length: 0)
		}
	}


	
	public func endIndexInString(_ string: String) -> String.Index? {
		return NSRange.indexForLocation(NSMaxRange(self), inString: string)
	}


	fileprivate static func indexForLocation(_ location: Int, inString string: String) -> String.Index? {
		if location == NSNotFound {
			return nil
		}

		let utf16 = string.utf16
		return utf16.index(utf16.startIndex, offsetBy: location, limitedBy: utf16.endIndex)?.samePosition(in: string)
	}


	fileprivate static func locationForIndex(_ index: String.Index, inString string: String) -> Int {
		let utf16 = string.utf16
		return utf16.distance(from: utf16.startIndex, to: index.samePosition(in: utf16))
	}


	
	public func rangeInString(_ string: String) -> Range<String.Index>? {
		if let startIndex = startIndexInString(string), let endIndex = endIndexInString(string) {
			return startIndex ..< endIndex
		}
		
		return nil
	}


	
	public func startIndexInString(_ string: String) -> String.Index? {
		return NSRange.indexForLocation(location, inString: string)
	}
}


extension NSRange: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "NSRange(location: \(location), length: \(length))"
	}
}


extension NSRange: CustomStringConvertible {

	public var description: String {
		return "(location: \(location), length: \(length))"
	}
}


extension NSRange: Equatable {}


public func == (a: NSRange, b: NSRange) -> Bool {
	return NSEqualRanges(a, b)
}

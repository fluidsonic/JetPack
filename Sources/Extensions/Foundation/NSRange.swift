import Foundation


public extension NSRange {

	public static let notFound = NSRange(location: NSNotFound, length: 0)


	public init(forString string: String) {
		let indices = string.indices

		self.init(range: indices.startIndex ..< indices.endIndex, inString: string)
	}


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


	public func clamped(to limits: NSRange) -> NSRange {
		if location == NSNotFound || limits.location == NSNotFound {
			return .notFound
		}

		let endLocation = self.endLocation
		if endLocation <= limits.location {
			return NSRange(location: limits.location, length: 0)
		}

		let endLocationLimit = limits.endLocation
		if endLocationLimit <= location {
			return NSRange(location: endLocationLimit, length: 0)
		}

		let clampedLocation = location.coerced(atLeast: limits.location)
		let clampedEndLocation = endLocation.coerced(atMost: endLocationLimit)

		return NSRange(location: clampedLocation, length: clampedEndLocation - clampedLocation)
	}

	
	public func endIndexInString(_ string: String) -> String.Index? {
		return NSRange.indexForLocation(NSMaxRange(self), inString: string)
	}


	public var endLocation: Int {
		guard location != NSNotFound else {
			return NSNotFound
		}

		return location + length
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
		guard let utf16Index = index.samePosition(in: utf16) else {
			return NSNotFound
		}

		return utf16.distance(from: utf16.startIndex, to: utf16Index)
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


	public func toCountableRange() -> CountableRange<Int>? {
		return Range(self).map { $0.lowerBound ..< $0.upperBound }
	}
}


extension NSRange: Sequence {

	public typealias Iterator = CountableRange<Int>.Iterator


	public func makeIterator() -> Iterator {
		guard location != NSNotFound else {
			return (0 ..< 0).makeIterator()
		}

		return (location ..< (location + length)).makeIterator()
	}
}


public extension Range where Bound == Int {

	public func toNSRange() -> NSRange {
		return NSRange(location: lowerBound, length: upperBound - lowerBound)
	}
}

import Foundation


public extension NSRange {

	@nonobjc
	public init(forString string: String) {
		self.init(range: string.startIndex ..< string.endIndex, inString: string)
	}


	@nonobjc
	public init(range: Range<String.Index>?, inString string: String) {
		if let range = range {
			let location = NSRange.locationForIndex(range.startIndex, inString: string)
			let endLocation = NSRange.locationForIndex(range.endIndex, inString: string)

			self.init(location: location, length: location.distanceTo(endLocation))
		}
		else {
			self.init(location: NSNotFound, length: 0)
		}
	}


	@warn_unused_result
	public func endIndexInString(string: String) -> String.Index? {
		return NSRange.indexForLocation(NSMaxRange(self), inString: string)
	}


	private static func indexForLocation(location: Int, inString string: String) -> String.Index? {
		if location == NSNotFound {
			return nil
		}

		return string.utf16.startIndex.advancedBy(location, limit:string.utf16.endIndex).samePositionIn(string)
	}


	private static func locationForIndex(index: String.Index?, inString string: String) -> Int {
		if let index = index {
			return string.utf16.startIndex.distanceTo(index.samePositionIn(string.utf16))
		}

		return NSNotFound
	}


	@warn_unused_result
	public func startIndexInString(string: String) -> String.Index? {
		return NSRange.indexForLocation(location, inString: string)
	}


	@warn_unused_result
	public func rangeInString(string: String) -> Range<String.Index>? {
		if let startIndex = startIndexInString(string), endIndex = endIndexInString(string) {
			return startIndex ..< endIndex
		}
		
		return nil
	}
}

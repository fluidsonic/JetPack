import Foundation


extension NSRegularExpression {

	@nonobjc
	public func matches(_ string: String, options: MatchingOptions = []) -> Bool {
		return rangeOfFirstMatch(in: string, options: options, range: NSRange(forString: string)).location != NSNotFound
	}
}

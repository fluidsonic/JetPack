import Foundation


public extension NSURLComponents {

	@nonobjc
	public func appendQueryItem(name name: String, value: String?) {
		var queryItems = self.queryItems ?? []
		queryItems.append(NSURLQueryItem(name: name, value: value))
		self.queryItems = queryItems
	}


	@nonobjc
	public func firstQueryItem(named name: String) -> NSURLQueryItem? {
		return queryItems?.firstMatching { $0.name == name }
	}


	@nonobjc
	public func firstValueForQueryItem(named name: String) -> String? {
		return firstQueryItem(named: name)?.value
	}
}

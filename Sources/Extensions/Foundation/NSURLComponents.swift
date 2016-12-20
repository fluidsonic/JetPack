import Foundation


public extension URLComponents {

	public mutating func appendQueryItem(name: String, value: String?) {
		var queryItems = self.queryItems ?? []
		queryItems.append(URLQueryItem(name: name, value: value))
		self.queryItems = queryItems
	}


	
	public func firstQueryItem(named name: String) -> URLQueryItem? {
		return queryItems?.firstMatching { $0.name == name }
	}


	
	public func firstValueForQueryItem(named name: String) -> String? {
		return firstQueryItem(named: name)?.value
	}
}

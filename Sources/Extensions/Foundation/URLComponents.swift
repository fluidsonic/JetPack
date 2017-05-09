import Foundation


extension URLComponents {

	public mutating func appendQueryItem(name: String, value: String?) {
		var queryItems = self.queryItems ?? []
		queryItems.append(URLQueryItem(name: name, value: value))
		self.queryItems = queryItems
	}
}

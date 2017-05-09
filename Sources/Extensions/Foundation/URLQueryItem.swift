import Foundation


extension Sequence where Iterator.Element == URLQueryItem {

	public func first(named name: String) -> URLQueryItem? {
		return firstMatching { $0.name == name }
	}
}

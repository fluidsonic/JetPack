import Foundation


public extension UserDefaults {

	func date(forKey defaultName: String) -> Date? {
		return object(forKey: defaultName) as? Date
	}


	func decodable<Value: Decodable>(forKey defaultName: String) throws -> Value? {
		return try string(forKey: defaultName)
			.flatMap { $0.data(using: .utf8) }
			.map { try JSONDecoder().decode(Value.self, from: $0) }
	}


	func set<Value: Encodable>(encodable value: Value, forKey defaultName: String) throws {
		try set(String(data: JSONEncoder().encode(value), encoding: .utf8), forKey: defaultName)
	}
}

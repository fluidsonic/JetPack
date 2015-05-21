import Foundation


public enum Result<T> {
	case Failure(NSError)
	case Success(ResultValue<T>)


	public var error: NSError? {
		switch self {
		case let .Failure(error): return error
		case .Success:            return nil
		}
	}


	public static func failure(error: NSError) -> Result {
		return .Failure(error)
	}


	public var isFailure: Bool {
		switch self {
		case .Failure: return true
		case .Success: return false
		}
	}


	public var isSuccess: Bool {
		switch self {
		case .Failure: return false
		case .Success: return true
		}
	}


	public static func success(value: T) -> Result {
		return .Success(ResultValue(value))
	}


	public var value: T? {
		switch self {
		case .Failure:            return nil
		case let .Success(value): return value.value
		}
	}
}


extension Result: DebugPrintable {

	public var debugDescription: String {
		return description
	}
}


extension Result: Printable {

	public var description: String {
		switch self {
		case let .Failure(error): return "Failure(\(error))"
		case let .Success(value): return "Success(\(value))"
		}
	}
}



// Workaround for Swift limitation which does not support dynamically sized enum<T>.

public final class ResultValue<T> {

	private let value: T


	private init(_ value: T) {
		self.value = value
	}
}


extension ResultValue: DebugPrintable {

	public var debugDescription: String {
		return description
	}
}


extension ResultValue: Printable {

	public var description: String {
		return toString(value)
	}
}

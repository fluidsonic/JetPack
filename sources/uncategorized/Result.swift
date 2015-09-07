import Foundation


public enum Result<T> {
	case Failure(ErrorType)
	case Success(T)


	public var error: ErrorType? {
		switch self {
		case let .Failure(error): return error
		case .Success:            return nil
		}
	}


	public func get() throws -> T {
		switch self {
		case let .Failure(error): throw error
		case let .Success(value): return value
		}
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


	public var value: T? {
		switch self {
		case .Failure:            return nil
		case let .Success(value): return value
		}
	}
}


extension Result: CustomDebugStringConvertible {

	public var debugDescription: String {
		return description
	}
}


extension Result: CustomStringConvertible {

	public var description: String {
		switch self {
		case let .Failure(error): return "Failure(\(error))"
		case let .Success(value): return "Success(\(value))"
		}
	}
}

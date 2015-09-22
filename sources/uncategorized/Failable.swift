public enum Failable<Result> {
	case Failed(ErrorType)
	case Succeeded(Result)


	public var error: ErrorType? {
		switch self {
		case let .Failed(error): return error
		case .Succeeded:         return nil
		}
	}


	@warn_unused_result
	public func get() throws -> Result {
		switch self {
		case let .Failed(error):     throw error
		case let .Succeeded(result): return result
		}
	}


	public var isFailure: Bool {
		switch self {
		case .Failed:    return true
		case .Succeeded: return false
		}
	}


	public var isSuccess: Bool {
		switch self {
		case .Failed:    return false
		case .Succeeded: return true
		}
	}


	public var result: Result? {
		switch self {
		case .Failed:                return nil
		case let .Succeeded(result): return result
		}
	}
}


extension Failable: CustomDebugStringConvertible {

	public var debugDescription: String {
		switch self {
		case let .Failed(error):     return "Failed(\(String(reflecting: error)))"
		case let .Succeeded(result): return "Succeeded(\(String(reflecting: result)))"
		}
	}
}


extension Failable: CustomStringConvertible {

	public var description: String {
		switch self {
		case let .Failed(error):     return "Failed(\(error))"
		case let .Succeeded(result): return "Succeeded(\(result))"
		}
	}
}

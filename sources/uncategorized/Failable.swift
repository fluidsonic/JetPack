public enum Failable<Result> {
	case Failure(ErrorType)
	case Success(Result)


	public var error: ErrorType? {
		switch self {
		case let .Failure(error): return error
		case .Success:            return nil
		}
	}


	@warn_unused_result
	public func get() throws -> Result {
		switch self {
		case let .Failure(error): throw error
		case let .Success(result): return result
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


	public var result: Result? {
		switch self {
		case .Failure:             return nil
		case let .Success(result): return result
		}
	}
}


extension Failable: CustomDebugStringConvertible {

	public var debugDescription: String {
		return description
	}
}


extension Failable: CustomStringConvertible {

	public var description: String {
		switch self {
		case let .Failure(error):  return "Failure(\(error))"
		case let .Success(result): return "Success(\(result))"
		}
	}
}

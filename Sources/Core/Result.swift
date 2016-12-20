public struct Result<ValueType> {

	fileprivate typealias ResultType = _Result<ValueType,Failure>

	fileprivate let result: ResultType


	private init(result: ResultType) {
		self.result = result
	}


	public var failure: Failure? {
		switch result {
		case let .Failure(failure): return failure
		case .Success:              return nil
		}
	}


	@warn_unused_result
	public static func Failure(_ error: Error) -> Result<ValueType> {
		return .init(result: .Failure(error.asFailure()))
	}


	@warn_unused_result
	public func get() throws -> ValueType {
		switch result {
		case let .Failure(failure): throw failure
		case let .Success(value):   return value
		}
	}


	public var isFailure: Bool {
		switch result {
		case .Failure: return true
		case .Success: return false
		}
	}


	public var isSuccess: Bool {
		switch result {
		case .Failure:  return false
		case .Success: return true
		}
	}


	@warn_unused_result
	public static func Success(_ value: ValueType) -> Result<ValueType> {
		return .init(result: .Success(value))
	}


	public var value: ValueType? {
		switch result {
		case .Failure:            return nil
		case let .Success(value): return value
		}
	}
}


extension Result: CustomDebugStringConvertible {

	public var debugDescription: String {
		switch result {
		case let .Failure(failure): return "Failure(\(String(reflecting: failure)))"
		case let .Success(value):   return "Success(\(String(reflecting: value)))"
		}
	}
}


extension Result: CustomStringConvertible {

	public var description: String {
		switch result {
		case let .Failure(failure): return String(describing: failure)
		case let .Success(value):   return String(describing: value)
		}
	}
}



private enum _Result<ValueType,FailureType> {
	case Failure(FailureType)
	case Success(ValueType)
}

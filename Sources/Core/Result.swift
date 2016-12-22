public struct Result<SuccessValue> {

	fileprivate typealias Content = _Content<SuccessValue>

	fileprivate let content: Content


	private init(_ content: Content) {
		self.content = content
	}


	public var failure: Failure? {
		switch content {
		case let .failure(failure): return failure
		case .success:              return nil
		}
	}


	public static func failure(_ error: Error) -> Result<SuccessValue> {
		return .init(.failure(error.asFailure()))
	}


	public func get() throws -> SuccessValue {
		switch content {
		case let .failure(failure): throw failure
		case let .success(value):   return value
		}
	}


	public var isFailure: Bool {
		switch content {
		case .failure: return true
		case .success: return false
		}
	}


	public var isSuccess: Bool {
		switch content {
		case .failure:  return false
		case .success: return true
		}
	}


	public static func success(_ value: SuccessValue) -> Result<SuccessValue> {
		return .init(.success(value))
	}


	public var value: SuccessValue? {
		switch content {
		case .failure:            return nil
		case let .success(value): return value
		}
	}
}


extension Result: CustomDebugStringConvertible {

	public var debugDescription: String {
		switch content {
		case let .failure(failure): return "failure(\(String(reflecting: failure)))"
		case let .success(value):   return "success(\(String(reflecting: value)))"
		}
	}
}


extension Result: CustomStringConvertible {

	public var description: String {
		switch content {
		case let .failure(failure): return String(describing: failure)
		case let .success(value):   return String(describing: value)
		}
	}
}



private enum _Content<SuccessValue> {

	case failure(Failure)
	case success(SuccessValue)
}

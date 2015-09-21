public protocol Failure: CustomDebugStringConvertible, CustomStringConvertible, ErrorType {

	var cause: Failure? { get }
	var developerMessage: String { get }
	var isPermanent: Bool { get }
	var userMessage: String { get }
}


public extension Failure {

	public var cause: Failure? {
		return nil
	}


	public var debugDescription: String {
		return debugDescriptionForErrorTypeInstance(self)
	}


	private func debugDescriptionForErrorTypeInstance(instance: ErrorType) -> String {
		var debugDescription = String(reflecting: instance.dynamicType)
		if let displayStyle = Mirror(reflecting: instance).displayStyle where displayStyle == .Enum {
			debugDescription += ".Case#\(instance._code)" // Too bad we don't get the case's name yet. At least we have the index!
		}

		debugDescription += "("
		if developerMessage != userMessage {
			debugDescription += "userMessage: "
			debugDescription += String(reflecting: userMessage)
			debugDescription += ", developerMessage: "
			debugDescription += String(reflecting: developerMessage)
		}
		else {
			debugDescription += "message: "
			debugDescription += String(reflecting: userMessage)
		}
		debugDescription += ")"

		if let cause = cause {
			debugDescription += " caused by \(cause.debugDescription)"
		}

		return debugDescription
	}


	public var description: String {
		return userMessage
	}


	public var developerMessage: String {
		return userMessage
	}


	@available(*, unavailable, renamed="cause")
	public var failureCause: Failure? {
		return cause
	}


	@available(*, unavailable, renamed="developerMessage")
	public var failureDeveloperMessage: String {
		return developerMessage
	}


	@available(*, unavailable, renamed="isPermanent")
	public var failureIsPermanent: Bool {
		return isPermanent
	}


	@available(*, unavailable, renamed="userMessage")
	public var failureUserMessage: String {
		return userMessage
	}


	public var isPermanent: Bool {
		return true
	}
}


public extension ErrorType {

	public func asFailure() -> Failure {
		return asFailureWithDefaultUserMessage("An unknown error occurred.")
	}


	public func asFailureWithDefaultUserMessage(defaultUserMessage: String) -> Failure {
		if let failure = self as? Failure {
			return failure
		}

		if let error = originalNSError {
			return FailureForNSError(error: error, defaultUserMessage: defaultUserMessage)
		}
		else {
			return FailureForErrorType(error: self, defaultUserMessage: defaultUserMessage)
		}
	}


	public var failureCause: Failure? {
		return asFailure().cause
	}


	public var failureDeveloperMessage: String {
		return asFailure().developerMessage
	}


	public var failureIsPermanent: Bool {
		return asFailure().isPermanent
	}


	public var failureUserMessage: String {
		return asFailure().userMessage
	}
}



private struct FailureForErrorType: Failure {

	private let defaultUserMessage: String
	private let error: ErrorType


	private init(error: ErrorType, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error
	}


	private var debugDescription: String {
		return debugDescriptionForErrorTypeInstance(error)
	}


	private var developerMessage: String {
		guard let stringConvertible = error as? CustomDebugStringConvertible else {
			return userMessage
		}

		return stringConvertible.debugDescription
	}


	private var userMessage: String {
		guard let stringConvertible = error as? CustomStringConvertible else {
			return defaultUserMessage
		}

		return stringConvertible.description
	}
}



private class FailureForNSError: NSError, Failure {

	private let defaultUserMessage: String
	private let error: NSError


	private init(error: NSError, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error

		super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private var cause: Failure? {
		let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError
		return underlyingError?.asFailure()
	}


	private override var debugDescription: String {
		let error = self.error as NSError

		var debugDescription = ""
		debugDescription += String(reflecting: error.dynamicType)
		debugDescription += "(domain: "
		debugDescription += error.domain.isEmpty ? "<empty>" : String(reflecting: error.domain)
		debugDescription += ", code: "
		debugDescription += String(error.code)

		if let localizedDescription = error.userInfo[NSLocalizedDescriptionKey] as? String where !localizedDescription.isEmpty {
			debugDescription += ", message: "
			debugDescription += String(reflecting: localizedDescription)
		}

		var userInfo = error.userInfo
		userInfo[NSLocalizedDescriptionKey] = nil
		userInfo[NSUnderlyingErrorKey] = nil
		if !userInfo.isEmpty {
			debugDescription += ", userInfo: "
			debugDescription += String(reflecting: userInfo)
		}

		debugDescription += ")"

		if let cause = cause {
			debugDescription += " caused by \(cause.debugDescription)"
		}

		return debugDescription
	}


	private var developerMessage: String {
		let error = self.error as NSError
		return error.description
	}


	private var userMessage: String {
		let error = self.error as NSError
		guard let localizedDescription = error.userInfo[NSLocalizedDescriptionKey] as? String where !localizedDescription.isEmpty else {
			return defaultUserMessage
		}
		
		return localizedDescription
	}
}

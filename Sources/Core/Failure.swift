import Foundation


public protocol Failure: CustomDebugStringConvertible, CustomStringConvertible, Error {

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


	fileprivate func debugDescriptionForErrorTypeInstance(_ instance: Error) -> String {
		var debugDescription = String(reflecting: type(of: instance))
		if let displayStyle = Mirror(reflecting: instance).displayStyle, displayStyle == .enum {
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


	public var isPermanent: Bool {
		return true
	}
}


public extension Error {

	public func asFailure() -> Failure {
		return asFailureWithDefaultUserMessage("An unknown error occurred.")
	}


	public func asFailureWithDefaultUserMessage(_ defaultUserMessage: String) -> Failure {
		if let failure = self as? Failure {
			return failure
		}

		if let error = self as? NSObject as? NSError { // check if this really is an NSError and prevent a synthetic one
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

	fileprivate let defaultUserMessage: String
	fileprivate let error: Error


	fileprivate init(error: Error, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error
	}


	fileprivate var debugDescription: String {
		return debugDescriptionForErrorTypeInstance(error)
	}


	fileprivate var developerMessage: String {
		guard let stringConvertible = error as? CustomDebugStringConvertible else {
			return userMessage
		}

		return stringConvertible.debugDescription
	}


	fileprivate var userMessage: String {
		guard let stringConvertible = error as? CustomStringConvertible else {
			return defaultUserMessage
		}

		return stringConvertible.description
	}
}



private class FailureForNSError: NSError, Failure {

	fileprivate let defaultUserMessage: String
	fileprivate let error: NSError


	fileprivate init(error: NSError, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error

		super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	fileprivate var cause: Failure? {
		let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError
		return underlyingError?.asFailure()
	}


	fileprivate override var debugDescription: String {
		let error = self.error as NSError

		var debugDescription = ""
		debugDescription += String(reflecting: type(of: error))
		debugDescription += "(domain: "
		debugDescription += error.domain.isEmpty ? "<empty>" : String(reflecting: error.domain)
		debugDescription += ", code: "
		debugDescription += String(error.code)

		if let localizedDescription = error.userInfo[NSLocalizedDescriptionKey] as? String, !localizedDescription.isEmpty {
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


	fileprivate var developerMessage: String {
		let error = self.error as NSError
		return error.description
	}


	fileprivate var userMessage: String {
		let error = self.error as NSError
		guard let localizedDescription = error.userInfo[NSLocalizedDescriptionKey] as? String, !localizedDescription.isEmpty else {
			return defaultUserMessage
		}
		
		return localizedDescription
	}
}

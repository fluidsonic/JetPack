import Foundation


// TODO try to extend the Error protocol to support the additional functionality

public protocol Failure: CustomDebugStringConvertible, CustomStringConvertible, Error {

	var cause: Failure? { get }
	var developerMessage: String { get }
	var isPermanent: Bool { get }
	var userMessage: String { get }
}


extension Failure {

	public var cause: Failure? {
		return nil
	}


	public var debugDescription: String {
		return debugDescription(for: self)
	}


	fileprivate func debugDescription(for error: Error) -> String {
		var debugDescription = String(reflecting: type(of: error))
		if let displayStyle = Mirror(reflecting: error).displayStyle, displayStyle == .enum {
			debugDescription += ".Case#\(error._code)" // Too bad we don't get the case's name yet. At least we have the index!
		}

		let developerMessage = self.developerMessage
		let userMessage = self.userMessage

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



extension Error {

	public func asFailure() -> Failure {
		return asFailure(defaultUserMessage: "An unknown error occurred.")
	}


	public func asFailure(defaultUserMessage: String) -> Failure {
		if let failure = self as? Failure {
			return failure
		}

		if type(of: self) is NSError.Type {
			return NSErrorFailure(error: self as NSError, defaultUserMessage: defaultUserMessage)
		}
		else {
			return ErrorFailure(error: self, defaultUserMessage: defaultUserMessage)
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



fileprivate struct ErrorFailure: Failure {

	private let defaultUserMessage: String
	private let error: Error


	fileprivate init(error: Error, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error
	}


	fileprivate var debugDescription: String {
		return debugDescription(for: error)
	}


	fileprivate var developerMessage: String {
		if let stringConvertible = error as Any as? CustomDebugStringConvertible { // "as Any" avoids implicit cast to NSError
			return stringConvertible.debugDescription
		}

		return userMessage
	}


	fileprivate var userMessage: String {
		if let stringConvertible = error as Any as? CustomStringConvertible { // "as Any" avoids implicit cast to NSError
			return stringConvertible.description
		}

		return defaultUserMessage
	}
}



fileprivate class NSErrorFailure: NSError, Failure {

	private let defaultUserMessage: String
	private let error: NSError


	fileprivate init(error: NSError, defaultUserMessage: String) {
		self.defaultUserMessage = defaultUserMessage
		self.error = error

		super.init(domain: error.domain, code: error.code, userInfo: error.userInfo)
	}


	fileprivate required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	fileprivate var cause: Failure? {
		let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError
		return underlyingError?.asFailure()
	}


	fileprivate override var debugDescription: String {
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
		return error.description
	}


	fileprivate var userMessage: String {
		guard let localizedDescription = error.userInfo[NSLocalizedDescriptionKey] as? String, !localizedDescription.isEmpty else {
			return defaultUserMessage
		}
		
		return localizedDescription
	}
}

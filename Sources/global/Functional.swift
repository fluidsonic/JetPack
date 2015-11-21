import ObjectiveC


@warn_unused_result
internal func arc4random<Element: IntegerLiteralConvertible>() -> Element {
	var random: Element = 0
	arc4random_buf(&random, sizeof(Element))
	return random
}


internal func copyMethodWithSelector(selector: Selector, fromType: AnyClass, toType: AnyClass) {
	precondition(fromType != toType)

	let fromMethod = class_getInstanceMethod(fromType, selector)
	guard fromMethod != nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's not present in the former.")
		return
	}

	let toMethod = class_getInstanceMethod(toType, selector)
	guard toMethod == nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's already present in the latter.")
		return
	}

	let typePointer = method_getTypeEncoding(fromMethod)
	let implementation = method_getImplementation(fromMethod)

	guard typePointer != nil && implementation != nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's implementation details could not be access.")
		return
	}

	guard class_addMethod(toType, selector, implementation, typePointer) else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since `class_addMethod` vetoed.")
		return
	}
}


@warn_unused_result
public func makeEscapable<Parameters,Result>(@noescape closure: Parameters -> Result) -> Parameters -> Result {
	func cast<From,To>(instance: From) -> To {
		return (instance as Any) as! To
	}

	return cast(closure)
}


@warn_unused_result
public func not<Parameter>(closure: Parameter -> Bool) -> Parameter -> Bool {
	return { !closure($0) }
}


@warn_unused_result
public func not<Parameter>(closure: Parameter throws -> Bool) -> Parameter throws -> Bool {
	return { !(try closure($0)) }
}


internal func obfuscatedSelector(parts: String...) -> Selector {
	return Selector(parts.joinWithSeparator(""))
}


@warn_unused_result
public func optionalMax<Element: Comparable>(elements: Element? ...) -> Element? {
	var maximumElement: Element?

	for element in elements {
		if let element = element {
			if let existingMaximumElement = maximumElement {
				if element > existingMaximumElement {
					maximumElement = element
				}
			}
			else {
				maximumElement = element
			}
		}
	}

	return maximumElement
}


@warn_unused_result
public func optionalMin<Element: Comparable>(elements: Element? ...) -> Element? {
	var minimumElement: Element?

	for element in elements {
		if let element = element {
			if let existingMinimumElement = minimumElement {
				if element < existingMinimumElement {
					minimumElement = element
				}
			}
			else {
				minimumElement = element
			}
		}
	}

	return minimumElement
}


@warn_unused_result
public func pointerOf(object: AnyObject) -> COpaquePointer {
	return Unmanaged<AnyObject>.passUnretained(object).toOpaque()
}


internal func redirectMethodInType(type: AnyClass, fromSelector: Selector, toSelector: Selector) {
	precondition(fromSelector != toSelector)

	let fromMethod = class_getInstanceMethod(type, fromSelector)
	guard fromMethod != nil else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since the former is not present in '\(type)'.")
		return
	}

	let toMethod = class_getInstanceMethod(type, toSelector)
	guard toMethod != nil else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since the latter is not present in '\(type)'.")
		return
	}

	let fromTypePointer = method_getTypeEncoding(fromMethod)
	let toTypePointer = method_getTypeEncoding(toMethod)
	guard fromTypePointer != nil && toTypePointer != nil, let fromType = String.fromCString(fromTypePointer), toType = String.fromCString(toTypePointer) else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since their type encodings could not be accessed.")
		return
	}
	guard fromType == toType else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since their type encodings don't match: '\(fromType)' -> '\(toType)'.")
		return
	}

	method_setImplementation(fromMethod, method_getImplementation(toMethod))
}


public func swizzleMethodInType(type: AnyClass, fromSelector: Selector, toSelector: Selector) {
	precondition(fromSelector != toSelector)

	let fromMethod = class_getInstanceMethod(type, fromSelector)
	guard fromMethod != nil else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since the former is not present in '\(type)'.")
		return
	}

	let toMethod = class_getInstanceMethod(type, toSelector)
	guard toMethod != nil else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since the latter is not present in '\(type)'.")
		return
	}

	let fromTypePointer = method_getTypeEncoding(fromMethod)
	let toTypePointer = method_getTypeEncoding(toMethod)
	guard fromTypePointer != nil && toTypePointer != nil, let fromType = String.fromCString(fromTypePointer), toType = String.fromCString(toTypePointer) else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since their type encodings could not be accessed.")
		return
	}
	guard fromType == toType else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since their type encodings don't match: '\(fromType)' -> '\(toType)'.")
		return
	}

	method_exchangeImplementations(fromMethod, toMethod)
}


public func synchronized<ReturnType>(object: AnyObject, @noescape closure: Void throws -> ReturnType) rethrows -> ReturnType {
	objc_sync_enter(object)
	defer {
		objc_sync_exit(object)
	}

	return try closure()
}

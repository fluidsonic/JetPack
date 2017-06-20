import ObjectiveC


@inline(__always)
public func asObject(_ value: Any) -> AnyObject? {
	return isObject(value) ? value as AnyObject : nil
}


private func class_getInstanceMethodIgnoringSupertypes(_ clazz: AnyClass, _ name: Selector) -> Method? {
	let method = class_getInstanceMethod(clazz, name)

	if let superclass = class_getSuperclass(clazz) {
		let superclassMethod = class_getInstanceMethod(superclass, name)
		guard superclassMethod != method else {
			return nil
		}
	}

	return method!
}


internal func copyMethod(selector: Selector, from fromType: AnyClass, to toType: AnyClass) {
	precondition(fromType != toType)

	let fromMethod = class_getInstanceMethodIgnoringSupertypes(fromType, selector)
	guard fromMethod != nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's not present in the former.")
		return
	}

	let toMethod = class_getInstanceMethodIgnoringSupertypes(toType, selector)
	guard toMethod == nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's already present in the latter.")
		return
	}

	let typePointer = method_getTypeEncoding(fromMethod)
	let implementation = method_getImplementation(fromMethod)

	guard typePointer != nil && implementation != nil else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since it's implementation details could not be accessed.")
		return
	}

	guard class_addMethod(toType, selector, implementation, typePointer) else {
		log("Selector '\(selector)' was not moved from '\(fromType)' to '\(toType)' since `class_addMethod` vetoed.")
		return
	}
}


internal func copyMethod(in type: AnyClass, includingSupertypes: Bool = false, from fromSelector: Selector, to toSelector: Selector) {
	precondition(fromSelector != toSelector)

	let fromMethod = (includingSupertypes ? class_getInstanceMethod : class_getInstanceMethodIgnoringSupertypes)(type, fromSelector)
	guard fromMethod != nil else {
		log("Selector '\(fromSelector)' was not copied to '\(toSelector)' since the former not present in '\(type)'.")
		return
	}

	let toMethod = class_getInstanceMethodIgnoringSupertypes(type, toSelector)
	guard toMethod == nil else {
		log("Selector '\(fromSelector)' was not copied to '\(toSelector)' since the latter is already present in '\(type)'.")
		return
	}

	let typePointer = method_getTypeEncoding(fromMethod)
	let implementation = method_getImplementation(fromMethod)

	guard typePointer != nil && implementation != nil else {
		log("Selector '\(fromSelector)' was not copied to '\(toSelector)' in '\(type)' since it's implementation details could not be accessed.")
		return
	}

	guard class_addMethod(type, toSelector, implementation, typePointer) else {
		log("Selector '\(fromMethod)' was not copied to '\(toSelector)' in '\(type)' since `class_addMethod` vetoed.")
		return
	}
}


public func identity<Value>(_ value: Value) -> Value {
	return value
}


@inline(__always)
public func isObject(_ value: Any) -> Bool {
	return type(of: value) is AnyClass
}


public func lazyPlaceholder<Value>(file: StaticString = #file, line: UInt = #line) -> Value {
	fatalError("Lazy variable accessed before being initialized.", file: file, line: line)
}


public func makeEscapable<Parameters,Result>(_ closure: (Parameters) -> Result) -> (Parameters) -> Result {
	func cast<From,To>(_ instance: From) -> To {
		return (instance as Any) as! To
	}

	return cast(closure)
}


public func not<Parameter>(_ closure: @escaping (Parameter) -> Bool) -> (Parameter) -> Bool {
	return { !closure($0) }
}


public func not<Parameter>(_ closure: @escaping (Parameter) throws -> Bool) -> (Parameter) throws -> Bool {
	return { try !closure($0) }
}


public func obfuscatedSelector(_ parts: String...) -> Selector {
	return Selector(parts.joined(separator: ""))
}


public func optionalMax<Element: Comparable>(_ elements: Element? ...) -> Element? {
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


public func optionalMin<Element: Comparable>(_ elements: Element? ...) -> Element? {
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


public func pointer(of object: AnyObject) -> UnsafeMutableRawPointer {
	return Unmanaged<AnyObject>.passUnretained(object).toOpaque()
}


public func redirectMethod(in type: AnyClass, from fromSelector: Selector, to toSelector: Selector, in toType: AnyClass? = nil) {
	let actualToType: AnyClass = toType ?? type

	precondition(fromSelector != toSelector || type != actualToType)

	let fromMethod = class_getInstanceMethodIgnoringSupertypes(type, fromSelector)
	guard fromMethod != nil else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since the former is not present in '\(type)'.")
		return
	}

	let toMethod = class_getInstanceMethod(actualToType, toSelector)
	guard toMethod != nil else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since the latter is not present in '\(actualToType)'.")
		return
	}

	let fromMethodTypePointer = method_getTypeEncoding(fromMethod)
	let toMethodTypePointer = method_getTypeEncoding(toMethod)
	guard fromMethodTypePointer != nil && toMethodTypePointer != nil, let fromMethodType = String(validatingUTF8: fromMethodTypePointer!), let toMethodType = String(validatingUTF8: toMethodTypePointer!) else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since their type encodings could not be accessed.")
		return
	}
	guard fromMethodType == toMethodType else {
		log("Selector '\(fromSelector)' was not redirected to selector '\(toSelector)' since their type encodings don't match: '\(fromMethodType)' -> '\(toMethodType)'.")
		return
	}

	method_setImplementation(fromMethod, method_getImplementation(toMethod))
}


public func swizzleMethod(in type: AnyClass, from fromSelector: Selector, to toSelector: Selector) {
	precondition(fromSelector != toSelector)

	let fromMethod = class_getInstanceMethodIgnoringSupertypes(type, fromSelector)
	guard fromMethod != nil else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since the former is not present in '\(type)'.")
		return
	}

	let toMethod = class_getInstanceMethodIgnoringSupertypes(type, toSelector)
	guard toMethod != nil else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since the latter is not present in '\(type)'.")
		return
	}

	let fromTypePointer = method_getTypeEncoding(fromMethod)
	let toTypePointer = method_getTypeEncoding(toMethod)
	guard fromTypePointer != nil && toTypePointer != nil, let fromType = String(validatingUTF8: fromTypePointer!), let toType = String(validatingUTF8: toTypePointer!) else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since their type encodings could not be accessed.")
		return
	}
	guard fromType == toType else {
		log("Selector '\(fromSelector)' was not swizzled with selector '\(toSelector)' since their type encodings don't match: '\(fromType)' -> '\(toType)'.")
		return
	}

	method_exchangeImplementations(fromMethod, toMethod)
}


public func synchronized<ReturnType>(_ object: AnyObject, closure: () throws -> ReturnType) rethrows -> ReturnType {
	objc_sync_enter(object)
	defer { objc_sync_exit(object) }

	return try closure()
}

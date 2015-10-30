import ObjectiveC


@warn_unused_result
internal func arc4random<Element: IntegerLiteralConvertible>() -> Element {
	var random: Element = 0
	arc4random_buf(&random, sizeof(Element))
	return random
}


@warn_unused_result
public func makeEscapable<Parameters,Result>(@noescape closure: Parameters -> Result) -> Parameters -> Result {
	func cast<From,To>(instance: From) -> To {
		return instance as! To
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


internal func swizzleInType(type: NSObject.Type, fromSelector: Selector, toSelector: Selector) {
	precondition(fromSelector != toSelector)

	let fromMethod = class_getInstanceMethod(type, fromSelector)
	let toMethod = class_getInstanceMethod(type, toSelector)

	if class_addMethod(type, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod)) {
		class_replaceMethod(type, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod))
	}
	else {
		method_exchangeImplementations(fromMethod, toMethod)
	}
}


public func synchronized<ReturnType>(object: AnyObject, @noescape closure: Void throws -> ReturnType) rethrows -> ReturnType {
	objc_sync_enter(object)
	defer {
		objc_sync_exit(object)
	}

	return try closure()
}

import UIKit


public extension UIControl {

	fileprivate struct AssociatedKeys {
		fileprivate static var eventHandler = UInt8()
	}



	@nonobjc
	fileprivate func ensureEventHandler() -> EventHandler {
		return eventHandler ?? {
			let eventHandler = EventHandler(control: self)
			self.eventHandler = eventHandler
			return eventHandler
		}()
	}


	@nonobjc
	fileprivate var eventHandler: EventHandler? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.eventHandler) as? EventHandler }
		set { objc_setAssociatedObject(self, &AssociatedKeys.eventHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public var tapped: Closure? {
		get { return eventHandler?.tapped }
		set {
			if let tapped = newValue {
				ensureEventHandler().tapped = tapped
			}
			else {
				eventHandler?.tapped = nil
			}
		}
	}


	@nonobjc
	public var valueChanged: Closure? {
		get { return eventHandler?.valueChanged }
		set {
			if let valueChanged = newValue {
				ensureEventHandler().valueChanged = valueChanged
			}
			else {
				eventHandler?.valueChanged = nil
			}
		}
	}
}



private final class EventHandler: NSObject {

	fileprivate unowned var control: UIControl


	fileprivate init(control: UIControl) {
		self.control = control

		super.init()
	}


	@objc
	fileprivate func controlTapped() {
		tapped?()
	}


	@objc
	fileprivate func controlValueChanged() {
		valueChanged?()
	}


	fileprivate var tapped: Closure? {
		didSet {
			if tapped != nil {
				if oldValue == nil {
					control.addTarget(self, action: #selector(controlTapped), for: .touchUpInside)
				}
			}
			else {
				if oldValue != nil {
					control.removeTarget(self, action: #selector(controlTapped), for: .touchUpInside)
				}
			}
		}
	}


	fileprivate var valueChanged: Closure? {
		didSet {
			if valueChanged != nil {
				if oldValue == nil {
					control.addTarget(self, action: #selector(controlValueChanged), for: .editingChanged)
					control.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
				}
			}
			else {
				if oldValue != nil {
					control.removeTarget(self, action: #selector(controlValueChanged), for: .editingChanged)
					control.removeTarget(self, action: #selector(controlValueChanged), for: .touchUpInside)
				}
			}
		}
	}
}

import UIKit


public extension UIControl {

	private struct AssociatedKeys {
		private static var eventHandler = UInt8()
	}



	@nonobjc
	private func ensureEventHandler() -> EventHandler {
		return eventHandler ?? {
			let eventHandler = EventHandler(control: self)
			self.eventHandler = eventHandler
			return eventHandler
		}()
	}


	@nonobjc
	private var eventHandler: EventHandler? {
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

	private unowned var control: UIControl


	private init(control: UIControl) {
		self.control = control

		super.init()
	}


	@objc
	private func controlTapped() {
		tapped?()
	}


	@objc
	private func controlValueChanged() {
		valueChanged?()
	}


	private var tapped: Closure? {
		didSet {
			if tapped != nil {
				if oldValue == nil {
					control.addTarget(self, action: #selector(controlTapped), forControlEvents: .TouchUpInside)
				}
			}
			else {
				if oldValue != nil {
					control.removeTarget(self, action: #selector(controlTapped), forControlEvents: .TouchUpInside)
				}
			}
		}
	}


	private var valueChanged: Closure? {
		didSet {
			if valueChanged != nil {
				if oldValue == nil {
					control.addTarget(self, action: #selector(controlValueChanged), forControlEvents: .EditingChanged)
					control.addTarget(self, action: #selector(controlValueChanged), forControlEvents: .ValueChanged)
				}
			}
			else {
				if oldValue != nil {
					control.removeTarget(self, action: #selector(controlValueChanged), forControlEvents: .EditingChanged)
					control.removeTarget(self, action: #selector(controlValueChanged), forControlEvents: .TouchUpInside)
				}
			}
		}
	}
}

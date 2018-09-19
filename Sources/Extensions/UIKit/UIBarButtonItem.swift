import UIKit


public extension UIBarButtonItem {

	fileprivate struct AssociatedKeys {
		fileprivate static var handlerProxy = UInt8()
	}


	@nonobjc
	public convenience init(image: UIImage, style: UIBarButtonItem.Style = .plain, handler: Closure? = nil) {
		self.init(image: image, style: style, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	public convenience init(title: String, style: UIBarButtonItem.Style = .plain, handler: Closure? = nil) {
		self.init(title: title, style: style, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	public convenience init(systemItem: UIBarButtonItem.SystemItem, handler: Closure? = nil) {
		self.init(barButtonSystemItem: systemItem, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	fileprivate func ensureEventProxy() -> EventProxy {
		return eventProxy ?? {
			let eventProxy = EventProxy(item: self)
			self.eventProxy = eventProxy
			return eventProxy
		}()
	}


	@nonobjc
	fileprivate var eventProxy: EventProxy? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.handlerProxy) as? EventProxy }
		set { objc_setAssociatedObject(self, &AssociatedKeys.handlerProxy, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public static func fixedSpaceOfWidth(_ width: CGFloat) -> UIBarButtonItem {
		let item = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		item.width = width
		return item
	}


	@nonobjc
	public static func flexibleSpace() -> UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
	}


	@nonobjc
	public var handler: Closure? {
		get { return eventProxy?.handler }
		set {
			if let handler = newValue {
				ensureEventProxy().handler = handler
			}
			else {
				eventProxy?.handler = nil
				eventProxy = nil
			}
		}
	}
}



private final class EventProxy: NSObject {

	fileprivate unowned var item: UIBarButtonItem


	fileprivate init(item: UIBarButtonItem) {
		self.item = item

		super.init()
	}


	@objc
	fileprivate func action() {
		handler?()
	}


	fileprivate var handler: Closure? {
		didSet {
			if handler != nil {
				item.target = self
				item.action = #selector(action)
			}
			else {
				item.target = nil
				item.action = nil
			}
		}
	}
}

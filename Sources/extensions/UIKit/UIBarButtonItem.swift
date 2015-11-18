import UIKit


public extension UIBarButtonItem {

	private struct AssociatedKeys {
		private static var handlerProxy = UInt8()
	}

	

	@nonobjc
	public convenience init(image: UIImage, style: UIBarButtonItemStyle = .Plain, handler: Closure? = nil) {
		self.init(image: image, style: style, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	public convenience init(title: String, style: UIBarButtonItemStyle = .Plain, handler: Closure? = nil) {
		self.init(title: title, style: style, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	public convenience init(systemItem: UIBarButtonSystemItem, handler: Closure? = nil) {
		self.init(barButtonSystemItem: systemItem, target: nil, action: nil)

		self.handler = handler
	}


	@nonobjc
	private func ensureEventProxy() -> EventProxy {
		return eventProxy ?? {
			let eventProxy = EventProxy(item: self)
			self.eventProxy = eventProxy
			return eventProxy
		}()
	}


	@nonobjc
	private var eventProxy: EventProxy? {
		get { return objc_getAssociatedObject(self, &AssociatedKeys.handlerProxy) as? EventProxy }
		set { objc_setAssociatedObject(self, &AssociatedKeys.handlerProxy, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}


	@nonobjc
	public static func fixedSpaceOfWidth(width: CGFloat) -> UIBarButtonItem {
		let item = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		item.width = width
		return item
	}


	@nonobjc
	public static func flexibleSpace() -> UIBarButtonItem {
		return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
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

	private unowned var item: UIBarButtonItem


	private init(item: UIBarButtonItem) {
		self.item = item

		super.init()
	}


	@objc
	private func action() {
		handler?()
	}


	private var handler: Closure? {
		didSet {
			if handler != nil {
				item.target = self
				item.action = "action"
			}
			else {
				item.target = nil
				item.action = nil
			}
		}
	}
}

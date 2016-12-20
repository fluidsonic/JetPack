import UIKit


@objc(JetPack_Window)
open /* non-final */ class Window: _Window {

	public override convenience init() {
		self.init(workaroundForSubclassing: ())
	}


	public init(workaroundForSubclassing: Void) {
		super.init()

		if bounds.isEmpty {
			frame = UIScreen.main.bounds
		}
	}


	@available(*, unavailable, message: "You must use init() since init(frame:) does no longer set-up the window properly in multitasking environments. In any case you can still set the frame manually after creating the window.")
	public dynamic override init(frame: CGRect) {
		// not supposed to be called
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open override class func initialize() {
		guard self == Window.self else {
			return
		}

		redirectMethodInType(self, fromSelector: #selector(UIView.init(frame:)), toSelector: #selector(UIView.init(frame:)), inType: UIWindow.self)
	}


	open override var rootViewController: UIViewController? {
		get { return super.rootViewController }
		set {
			guard newValue !== rootViewController else {
				return
			}

			// Due to a bug in iOS 8 changing the rootViewController doesn't remove modally presented view controllers.

			super.rootViewController = nil
			removeAllSubviews()
			super.rootViewController = newValue
		}
	}
}


extension Window: _NonSystemWindow {}



// fix to make init() the designated initializers of Window
@objc(_JetPack_Window)
open /* non-final */ class _Window: UIWindow {

	fileprivate dynamic init() {
		// not supposed to be called
		super.init(frame: UIScreen.main.bounds)
	}


	fileprivate dynamic override init(frame: CGRect) {
		// not supposed to be called
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	open override class func initialize() {
		guard self == _Window.self else {
			return
		}

		redirectMethodInType(self, fromSelector: #selector(NSObject.init),       toSelector: #selector(NSObject.init),       inType: UIWindow.self)
		redirectMethodInType(self, fromSelector: #selector(UIView.init(frame:)), toSelector: #selector(UIView.init(frame:)), inType: UIWindow.self)
	}
}

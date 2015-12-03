import UIKit


@IBDesignable
public /* non-final */ class Window: _WindowInitHack {

	public override convenience init() {
		self.init(workaroundForSubclassing: ())
	}


	public init(workaroundForSubclassing: Void) {
		super.init()
	}


	@available(*, unavailable, message="You must use init() since init(frame:) does no longer set-up the window properly in multitasking environments. In any case you can still set the frame manually after creating the window.")
	public dynamic override init(frame: CGRect) {
		// not supposed to be called
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	public override var rootViewController: UIViewController? {
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


	internal static func Window_setUp() {
		redirectMethodInType(self, fromSelector: "initWithFrame:", toSelector: "initWithFrame:", inType: UIWindow.self)

		_WindowInitHack._WindowInitHack_setUp()
	}
}



public /* non-final */ class _WindowInitHack: UIWindow {

	private dynamic init() {
		// not supposed to be called
		super.init(frame: UIScreen.mainScreen().bounds)
	}


	private dynamic override init(frame: CGRect) {
		// not supposed to be called
		super.init(frame: frame)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	internal static func _WindowInitHack_setUp() {
		redirectMethodInType(self, fromSelector: "init",           toSelector: "init",           inType: UIWindow.self)
		redirectMethodInType(self, fromSelector: "initWithFrame:", toSelector: "initWithFrame:", inType: UIWindow.self)
	}
}

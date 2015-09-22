@IBDesignable
public /* non-final */ class Window: UIWindow {

	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}


	#if TARGET_INTERFACE_BUILDER
		public required override convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#else
		public override convenience init(frame: CGRect) {
			self.init()

			self.frame = frame
		}
	#endif


	public override var rootViewController: UIViewController? {
		get { return super.rootViewController }
		set {
			// Due to a bug in iOS 8 changing the rootViewController doesn't remove modally presented view controllers.

			super.rootViewController = nil
			removeAllSubviews()
			super.rootViewController = newValue
		}
	}
}

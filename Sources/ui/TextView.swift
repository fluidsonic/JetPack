import UIKit


@objc(JetPack_TextView)
public /* non-final */ class TextView: UITextView {

	private var changeObserver: NSObjectProtocol?
	private var placeholderLabel: Label?


	public init() {
		super.init(frame: .zero, textContainer: nil)

		subscribeToChangeNotifications()
	}


	public required init?(coder: NSCoder) {
		super.init(coder: coder)

		subscribeToChangeNotifications()
	}


	deinit {
		if let changeObserver = changeObserver {
			NSNotificationCenter.defaultCenter().removeObserver(changeObserver)
		}
	}


	public override var attributedText: NSAttributedString? {
		get { return super.attributedText }
		set {
			guard newValue != attributedText else {
				return
			}

			if (newValue?.string.nonEmpty != nil) != (attributedText?.string.nonEmpty != nil) {
				setNeedsLayout()
			}

			super.attributedText = newValue
		}
	}


	public override var font: UIFont? {
		get { return super.font }
		set {
			guard newValue != font else {
				return
			}

			super.font = newValue
			placeholderLabel?.font = newValue

			setNeedsLayout()
		}
	}


	public override func layoutSubviews() {
		super.layoutSubviews()

		updatePlaceholderLabel()
	}


	public var placeholder = "" {
		didSet {
			guard placeholder != oldValue else {
				return
			}

			placeholderLabel?.text = placeholder

			setNeedsLayout()
		}
	}


	public var placeholderTextColor = UIColor(rgb: 0xC7C7CD) {
		didSet {
			placeholderLabel?.textColor = placeholderTextColor
		}
	}


	private func subscribeToChangeNotifications() {
		changeObserver = NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: self, queue: nil) { _ in
			self.updatePlaceholderLabel()
		}
	}


	public override var text: String? {
		get { return super.text }
		set {
			guard newValue != text else {
				return
			}

			if (newValue?.nonEmpty != nil) != (text?.nonEmpty != nil) {
				setNeedsLayout()
			}

			super.text = newValue
		}
	}


	public override var textContainerInset: UIEdgeInsets {
		get { return super.textContainerInset }
		set {
			guard newValue != textContainerInset else {
				return
			}

			super.textContainerInset = newValue

			setNeedsLayout()
		}
	}


	private func updatePlaceholderLabel() {
		if text?.nonEmpty != nil || placeholder.isEmpty {
			placeholderLabel?.removeFromSuperview()
		}
		else {
			let placeholderLabel = self.placeholderLabel ?? {
				let child = Label()
				child.font = font
				child.text = placeholder
				child.textColor = placeholderTextColor

				self.placeholderLabel = child

				return child
				}()

			if placeholderLabel.superview == nil {
				insertSubview(placeholderLabel, atIndex: 0)
			}

			var insets = textContainerInset
			insets.left += textContainer.lineFragmentPadding

			var placeholderLabelFrame = bounds.insetBy(insets)
			placeholderLabelFrame.size = placeholderLabel.sizeThatFitsSize(placeholderLabelFrame.size, allowsTruncation: true)
			placeholderLabel.frame = placeholderLabelFrame
		}
	}
}

import UIKit


@objc(JetPack_TextView)
open /* non-final */ class TextView: UITextView {

	fileprivate var changeObserver: NSObjectProtocol?
	fileprivate var placeholderLabel: Label?


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
			NotificationCenter.default.removeObserver(changeObserver)
		}
	}


	open override var attributedText: NSAttributedString? {
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


	open override var font: UIFont? {
		get { return super.font }
		set {
			guard let newValue = newValue, newValue != font else {
				return
			}

			super.font = newValue
			placeholderLabel?.font = newValue

			setNeedsLayout()
		}
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		updatePlaceholderLabel()
	}


	open var placeholder = "" {
		didSet {
			guard placeholder != oldValue else {
				return
			}

			placeholderLabel?.text = placeholder

			setNeedsLayout()
		}
	}


	open var placeholderTextColor = UIColor(rgb: 0xC7C7CD) {
		didSet {
			placeholderLabel?.textColor = placeholderTextColor
		}
	}


	fileprivate func subscribeToChangeNotifications() {
		changeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: self, queue: nil) { _ in
			self.updatePlaceholderLabel()
		}
	}


	open override var text: String? {
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


	open override var textContainerInset: UIEdgeInsets {
		get { return super.textContainerInset }
		set {
			guard newValue != textContainerInset else {
				return
			}

			super.textContainerInset = newValue

			setNeedsLayout()
		}
	}


	fileprivate func updatePlaceholderLabel() {
		if text?.nonEmpty != nil || placeholder.isEmpty {
			placeholderLabel?.removeFromSuperview()
		}
		else {
			let placeholderLabel = self.placeholderLabel ?? {
				let child = Label()
				if let font = font {
					child.font = font
				}
				child.maximumNumberOfLines = nil
				child.text = placeholder
				child.textColor = placeholderTextColor

				self.placeholderLabel = child

				return child
				}()

			if placeholderLabel.superview == nil {
				insertSubview(placeholderLabel, at: 0)
			}

			var insets = textContainerInset
			insets.left += textContainer.lineFragmentPadding

			var placeholderLabelFrame = bounds.insetBy(insets)
			placeholderLabelFrame.size = placeholderLabel.sizeThatFitsSize(placeholderLabelFrame.size, allowsTruncation: true)
			placeholderLabel.frame = placeholderLabelFrame
		}
	}
}

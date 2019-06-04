import UIKit


@objc(JetPack_TextView)
open class TextView: UITextView {

	private var changeObserver: NSObjectProtocol?
	private var placeholderLabel: UILabel?


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

			super.attributedText = attributedTextIncludingDefaultFormatting(for: newValue ?? NSAttributedString())
		}
	}


	private func attributedTextIncludingDefaultFormatting(for attributedText: NSAttributedString) -> NSAttributedString {
		let defaultAttributes: [NSAttributedString.Key : Any] = [
			.font:            font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
			.foregroundColor: textColor ?? UIColor.darkText
		]

		let attributedStringIncludingDefaultFormatting = NSMutableAttributedString(string: attributedText.string, attributes: defaultAttributes)
		attributedStringIncludingDefaultFormatting.beginEditing()
		attributedText.enumerateAttributes(in: NSRange(forString: attributedText.string), options: [.longestEffectiveRangeNotRequired]) { attributes, range, _ in
			attributedStringIncludingDefaultFormatting.addAttributes(attributes, range: range)
		}
		attributedStringIncludingDefaultFormatting.endEditing()

		return attributedStringIncludingDefaultFormatting
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


	private func subscribeToChangeNotifications() {
		changeObserver = NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: nil) { _ in
			self.updatePlaceholderLabel()
		}
	}


	open override var text: String? {
		get { return super.text }
		set { attributedText = newValue.map(NSAttributedString.init(string:)) }
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


	private func updatePlaceholderLabel() {
		if text?.nonEmpty != nil || placeholder.isEmpty {
			placeholderLabel?.removeFromSuperview()
		}
		else {
			let placeholderLabel = self.placeholderLabel ?? {
				let child = UILabel()
				if let font = font {
					child.font = font
				}
				child.numberOfLines = 0
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

			var placeholderLabelFrame = bounds.inset(by: insets)
			placeholderLabelFrame.size = placeholderLabel.sizeThatFitsSize(placeholderLabelFrame.size, allowsTruncation: true)
			placeholderLabel.frame = placeholderLabelFrame
		}
	}
}

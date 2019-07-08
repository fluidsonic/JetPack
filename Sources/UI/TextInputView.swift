import UIKit


open class TextInputView: View {

	public typealias Delegate = _TextInputViewDelegate

	private var lastLayoutedSize = CGSize.zero
	private var lastMeasuredNativeHeight = CGFloat(0)
	private let nativeView = NativeView()
	private var placeholderView: Label?

	public weak var delegate: Delegate?


	public override init() {
		super.init()

		setUp()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	open var attributedText: NSAttributedString {
		get { return nativeView.attributedText ?? NSAttributedString() }
		set { nativeView.attributedText = newValue }
	}


	@discardableResult
	open override func becomeFirstResponder() -> Bool {
		return nativeView.becomeFirstResponder()
	}


	private func checkIntrinsicContentSize() {
		let measuredNativeHeight = nativeView.heightThatFitsWidth(nativeView.bounds.width)
		guard measuredNativeHeight != lastMeasuredNativeHeight else {
			return
		}

		lastMeasuredNativeHeight = measuredNativeHeight

		invalidateIntrinsicContentSize()
	}


	open override func endEditing(_ force: Bool) -> Bool {
		return nativeView.endEditing(force)
	}


	open var font: UIFont {
		get { return nativeView.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize) }
		set {
			nativeView.font = newValue
			placeholderView?.font = newValue
		}
	}


	open var isScrollEnabled: Bool {
		get { return nativeView.isScrollEnabled }
		set { nativeView.isScrollEnabled = newValue }
	}


	open override func layoutSubviews() {
		super.layoutSubviews()

		let bounds = self.bounds
		nativeView.frame = CGRect(size: bounds.size)
		placeholderView?.frame = CGRect(size: bounds.size)

		if bounds.size != lastLayoutedSize {
			lastLayoutedSize = bounds.size
			lastMeasuredNativeHeight = nativeView.heightThatFitsWidth(nativeView.bounds.width)
		}
	}


	open override func measureOptimalSize(forAvailableSize availableSize: CGSize) -> CGSize {
		return nativeView.sizeThatFitsSize(availableSize)
	}


	fileprivate func nativeViewDidChange() {
		updatePlaceholderView()
		checkIntrinsicContentSize()

		delegate?.textInputViewDidChange(self)
	}


	fileprivate func nativeViewDidEndEditing() {
		checkIntrinsicContentSize()
	}


	open var padding: UIEdgeInsets {
		get { return nativeView.textContainerInset }
		set { nativeView.textContainerInset = newValue }
	}


	open var placeholder = "" {
		didSet {
			guard placeholder != oldValue else {
				return
			}

			updatePlaceholderView()
		}
	}


	open var placeholderTextColor = UIColor(rgb: 0xC7C7CD) {
		didSet {
			placeholderView?.textColor = placeholderTextColor
		}
	}


	@discardableResult
	open override func resignFirstResponder() -> Bool {
		return nativeView.resignFirstResponder()
	}


	private func setUp() {
		setUpNativeView()
	}


	private func setUpNativeView() {
		let child = nativeView
		child.backgroundColor = nil
		child.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
		child.parent = self
		child.textContainer.lineFragmentPadding = 0

		addSubview(child)
	}


	private func setUpPlaceholderView() -> Label {
		if let child = placeholderView {
			return child
		}

		let child = Label()
		child.font = font
		child.maximumNumberOfLines = nil
		child.padding = padding
		child.textColor = placeholderTextColor

		placeholderView = child
		addSubview(child)

		return child
	}


	open override func subviewDidInvalidateIntrinsicContentSize(_ view: UIView) {
		super.subviewDidInvalidateIntrinsicContentSize(view)

		guard view !== nativeView else {
			return // FIXME only text editing
		}

		setNeedsLayout()

		if !isScrollEnabled {
			invalidateIntrinsicContentSize()
		}
	}


	open var text: String {
		get { return nativeView.text ?? "" }
		set { nativeView.text = newValue }
	}


	open var textColor: UIColor {
		get { return nativeView.textColor ?? UIColor.darkText }
		set { nativeView.textColor = newValue }
	}


	open var typingAttributes: [NSAttributedString.Key : Any] {
		get { return nativeView.typingAttributes }
		set { nativeView.typingAttributes = newValue }
	}


	private func updatePlaceholderView() {
		if placeholder.isEmpty || !text.isEmpty {
			placeholderView?.removeFromSuperview()
			placeholderView = nil
		}
		else {
			let placeholderView = setUpPlaceholderView()
			placeholderView.text = placeholder
		}
	}
}


public protocol _TextInputViewDelegate: class {

	func textInputViewDidChange (_ inputView: TextInputView)
}



private final class NativeView: UITextView {

	weak var parent: TextInputView?


	init() {
		super.init(frame: .zero, textContainer: nil)

		delegate = self
	}


	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	override var attributedText: NSAttributedString? {
		get { return super.attributedText }
		set {
			guard newValue != attributedText else {
				return
			}

			super.attributedText = textIncludingDefaultAttributes(for: newValue ?? NSAttributedString())
		}
	}


	private func textIncludingDefaultAttributes(for attributedText: NSAttributedString) -> NSAttributedString {
		let defaultAttributes: [NSAttributedString.Key : Any] = [
			.font:            font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
			.foregroundColor: textColor ?? .darkText
		]

		let textIncludingDefaultAttributes = NSMutableAttributedString(string: attributedText.string, attributes: defaultAttributes)
		textIncludingDefaultAttributes.beginEditing()
		attributedText.enumerateAttributes(in: NSRange(forString: attributedText.string), options: [.longestEffectiveRangeNotRequired]) { attributes, range, _ in
			textIncludingDefaultAttributes.addAttributes(attributes, range: range)
		}
		textIncludingDefaultAttributes.endEditing()

		return textIncludingDefaultAttributes
	}


	override var text: String? {
		get { return super.text }
		set { attributedText = newValue.map(NSAttributedString.init(string:)) }
	}
}


extension NativeView: UITextViewDelegate {

	func textViewDidChange(_ textView: UITextView) {
		parent?.nativeViewDidChange()
	}


	func textViewDidEndEditing(_ textView: UITextView) {
		parent?.nativeViewDidEndEditing()
	}
}

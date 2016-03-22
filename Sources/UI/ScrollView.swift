import UIKit


@objc(JetPack_ScrollView)
public /* non-final */ class ScrollView: UIScrollView {

	private var delegateRespondsToViewForZooming = false

	public var centersViewForZooming = true


	public init() {
		super.init(frame: .zero)
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func centerViewForZooming() {
		guard centersViewForZooming && delegateRespondsToViewForZooming else {
			return
		}

		guard let viewForZooming = delegate?.viewForZoomingInScrollView?(self) where viewForZooming.superview === self else {
			return
		}

		let availableSize = bounds.size.insetBy(self.contentInset)

		var viewForZoomingFrame = viewForZooming.convertRect(viewForZooming.bounds, toView: self)
		if viewForZoomingFrame.width < availableSize.width {
			viewForZoomingFrame.left = (availableSize.width - viewForZoomingFrame.width) / 2
		}
		else {
			viewForZoomingFrame.left = 0
		}

		if viewForZoomingFrame.height < availableSize.height {
			viewForZoomingFrame.top = (availableSize.height - viewForZoomingFrame.height) / 2
		}
		else {
			viewForZoomingFrame.top = 0
		}

		viewForZooming.center = viewForZoomingFrame.center
	}


	public override var contentInset: UIEdgeInsets {
		get { return super.contentInset }
		set {
			guard newValue != contentInset else {
				return
			}

			super.contentInset = newValue

			centerViewForZooming()
		}
	}


	public override var contentOffset: CGPoint {
		get { return super.contentOffset }
		set {
			guard newValue != contentOffset else {
				return
			}

			super.contentOffset = newValue

			centerViewForZooming()
		}
	}


	public override var contentSize: CGSize {
		get { return super.contentSize }
		set {
			guard newValue != contentSize else {
				return
			}

			super.contentSize = newValue

			centerViewForZooming()
		}
	}


	public override weak var delegate: UIScrollViewDelegate? {
		get { return super.delegate }
		set {
			super.delegate = newValue

			delegateRespondsToViewForZooming = super.delegate?.respondsToSelector(#selector(UIScrollViewDelegate.viewForZoomingInScrollView(_:))) ?? false
		}
	}


	public override func layoutSubviews() {
		super.layoutSubviews()

		centerViewForZooming()
	}
}

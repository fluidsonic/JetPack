import CoreGraphics


public struct PartialSize: CustomDebugStringConvertible, Hashable {

	public var height: CGFloat?
	public var width: CGFloat?


	public init(width: CGFloat? = nil, height: CGFloat? = nil) {
		self.height = height
		self.width = width
	}


	public init(square: CGFloat?) {
		self.height = square
		self.width = square
	}


	public var debugDescription: String {
		return "(\(width?.description ?? "nil"), \(height?.description ?? "nil"))"
	}


	public var hashValue: Int {
		return (height?.hashValue ?? 0) ^ (width?.hashValue ?? 0)
	}


	public func toSize() -> CGSize? {
		guard let height = height, let width = width else {
			return nil
		}

		return CGSize(width: width, height: height)
	}


	public static func == (a: PartialSize, b: PartialSize) -> Bool {
		return a.height == b.height && a.width == b.width
	}
}



extension CGSize {

	public func coerced(atLeast minimum: PartialSize) -> CGSize {
		var coercedSize = self
		if let minimumWidth = minimum.width {
			coercedSize.width = coercedSize.width.coerced(atLeast: minimumWidth)
		}
		if let minimumHeight = minimum.height {
			coercedSize.height = coercedSize.height.coerced(atLeast: minimumHeight)
		}

		return coercedSize
	}


	public func coerced(atMost maximum: PartialSize) -> CGSize {
		var coercedSize = self
		if let maximumWidth = maximum.width {
			coercedSize.width = coercedSize.width.coerced(atMost: maximumWidth)
		}
		if let maximumHeight = maximum.height {
			coercedSize.height = coercedSize.height.coerced(atMost: maximumHeight)
		}

		return coercedSize
	}


	public func coerced(atLeast minimum: PartialSize, atMost maximum: PartialSize) -> CGSize {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	public func coerced(atLeast minimum: CGSize, atMost maximum: PartialSize) -> CGSize {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	public func coerced(atLeast minimum: PartialSize, atMost maximum: CGSize) -> CGSize {
		return coerced(atMost: maximum).coerced(atLeast: minimum)
	}


	public func toPartial() -> PartialSize {
		return PartialSize(width: width, height: height)
	}
}

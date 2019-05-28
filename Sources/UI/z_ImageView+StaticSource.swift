// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import UIKit


public extension ImageView {

	struct StaticSource: Source, Equatable {

		public var image: UIImage


		public init(image: UIImage) {
			self.image = image
		}


		public func createSession() -> Session? {
			return nil
		}


		public var staticImage: UIImage? {
			return image
		}
	}
}


public func == (a: ImageView.StaticSource, b: ImageView.StaticSource) -> Bool {
	return a.image == b.image
}

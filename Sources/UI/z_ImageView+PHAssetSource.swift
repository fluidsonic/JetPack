// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

// TODO
// - allow passing PHImageRequestOptions, copy it and set .synchronous to false
// - allow using a custom PHImageManager, e.g. PHCachingImageManager

import Photos
import UIKit


public extension ImageView {

	public struct PHAssetSource: Source, Equatable {

		public var asset: PHAsset


		public init(asset: PHAsset) {
			self.asset = asset
		}


		public func createSession() -> Session? {
			return PHAssetSourceSession(source: self)
		}


		public var staticImage: UIImage? {
			return nil
		}
	}
}


public func == (a: ImageView.PHAssetSource, b: ImageView.PHAssetSource) -> Bool {
	return a.asset == b.asset
}



private final class PHAssetSourceSession: ImageView.Session {

	fileprivate var lastRequestedContentMode: PHImageContentMode?
	fileprivate var lastRequestedSize = CGSize()
	fileprivate var listener: ImageView.SessionListener?
	fileprivate var requestId: PHImageRequestID?
	fileprivate let source: ImageView.PHAssetSource


	fileprivate init(source: ImageView.PHAssetSource) {
		self.source = source
	}


	fileprivate func imageViewDidChangeConfiguration(_ imageView: ImageView) {
		startOrRestartRequestForImageView(imageView)
	}


	fileprivate func startOrRestartRequestForImageView(_ imageView: ImageView) {
		let optimalSize = imageView.optimalImageSize
		var size = self.lastRequestedSize
		size.width = max(size.width, optimalSize.width)
		size.height = max(size.height, optimalSize.height)

		let contentMode: PHImageContentMode
		switch imageView.scaling {
		case .fitInside, .none:
			contentMode = .aspectFit

		case .fitHorizontally, .fitHorizontallyIgnoringAspectRatio, .fitIgnoringAspectRatio, .fitOutside, .fitVertically, .fitVerticallyIgnoringAspectRatio:
			contentMode = .aspectFill
		}

		guard contentMode != lastRequestedContentMode || size != lastRequestedSize else {
			return
		}

		stopRequest()
		startRequestWithSize(size, contentMode: contentMode)
	}


	fileprivate func startRequestWithSize(_ size: CGSize, contentMode: PHImageContentMode) {
		precondition(self.requestId == nil)

		self.lastRequestedContentMode = contentMode
		self.lastRequestedSize = size

		let manager = PHImageManager.default()
		let options = PHImageRequestOptions()
		options.deliveryMode = .opportunistic
		options.isNetworkAccessAllowed = true
		options.resizeMode = .exact
		options.isSynchronous = false
		options.version = .current

		requestId = manager.requestImage(for: source.asset, targetSize: size, contentMode: contentMode, options: options) { image, _ in
			guard let image = image else {
				return
			}

			let imageSize = image.size.scaleBy(image.scale)

			self.lastRequestedSize.width = max(self.lastRequestedSize.width, imageSize.width)
			self.lastRequestedSize.height = max(self.lastRequestedSize.height, imageSize.height)

			self.listener?.sessionDidRetrieveImage(image)
		}
	}


	fileprivate func startRetrievingImageForImageView(_ imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(self.listener == nil)

		self.listener = listener

		self.startOrRestartRequestForImageView(imageView)
	}


	fileprivate func stopRetrievingImage() {
		listener = nil

		stopRequest()
	}


	fileprivate func stopRequest() {
		guard let requestId = requestId else {
			return
		}

		PHImageManager.default().cancelImageRequest(requestId)
		self.requestId = nil
	}
}

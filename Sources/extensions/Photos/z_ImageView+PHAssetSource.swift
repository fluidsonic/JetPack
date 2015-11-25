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

	private var lastRequestedContentMode = PHImageContentMode.Default
	private var lastRequestedSize = CGSize()
	private var listener: ImageView.SessionListener?
	private var requestId: PHImageRequestID?
	private let source: ImageView.PHAssetSource


	private init(source: ImageView.PHAssetSource) {
		self.source = source
	}


	private func imageViewDidChangeConfiguration(imageView: ImageView) {
		startOrRestartRequestForImageView(imageView)
	}


	private func startOrRestartRequestForImageView(imageView: ImageView) {
		let optimalSize = imageView.optimalImageSize
		var size = self.lastRequestedSize
		size.width = max(size.width, optimalSize.width)
		size.height = max(size.height, optimalSize.height)

		let contentMode: PHImageContentMode
		switch imageView.scaling {
		case .FitInside, .None:
			contentMode = .AspectFit

		case .FitHorizontally, .FitHorizontallyIgnoringAspectRatio, .FitIgnoringAspectRatio, .FitOutside, .FitVertically, .FitVerticallyIgnoringAspectRatio:
			contentMode = .AspectFill
		}

		guard contentMode != lastRequestedContentMode || size != lastRequestedSize else {
			return
		}

		stopRequest()
		startRequestWithSize(size, contentMode: contentMode)
	}


	private func startRequestWithSize(size: CGSize, contentMode: PHImageContentMode) {
		precondition(self.requestId == nil)

		self.lastRequestedContentMode = contentMode
		self.lastRequestedSize = size

		let manager = PHImageManager.defaultManager()
		let options = PHImageRequestOptions()
		options.deliveryMode = .Opportunistic
		options.networkAccessAllowed = true
		options.resizeMode = .Exact
		options.synchronous = false
		options.version = .Current

		requestId = manager.requestImageForAsset(source.asset, targetSize: size, contentMode: contentMode, options: options) { image, _ in
			guard let image = image else {
				return
			}

			let imageSize = image.size.scaleBy(image.scale)

			self.lastRequestedSize.width = max(self.lastRequestedSize.width, imageSize.width)
			self.lastRequestedSize.height = max(self.lastRequestedSize.height, imageSize.height)

			self.listener?.sessionDidRetrieveImage(image)
		}
	}


	private func startRetrievingImageForImageView(imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(self.listener == nil)

		self.listener = listener

		self.startOrRestartRequestForImageView(imageView)
	}


	private func stopRetrievingImage() {
		listener = nil

		stopRequest()
	}


	private func stopRequest() {
		guard let requestId = requestId else {
			return
		}

		PHImageManager.defaultManager().cancelImageRequest(requestId)
		self.requestId = nil
	}
}

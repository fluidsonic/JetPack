// TODO
// - allow passing PHImageRequestOptions, copy it and set .synchronous to false
// - allow using a custom PHImageManager, e.g. PHCachingImageManager

import Photos
import UIKit


public extension ImageView {

	public struct PHAssetSource: Source, Equatable {

		public var asset: PHAsset
		public var contentMode: PHImageContentMode
		public var targetSize: CGSize


		public init(asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) {
			self.asset = asset
			self.contentMode = contentMode
			self.targetSize = targetSize
		}


		public func retrieveImageForImageView(imageView: ImageView, completion: UIImage? -> Void) -> CancelClosure {
			let manager = PHImageManager.defaultManager()
			let options = PHImageRequestOptions()
			options.deliveryMode = .Opportunistic
			options.networkAccessAllowed = true
			options.resizeMode = .Exact
			options.synchronous = false
			options.version = .Current

			var cancelled = false

			let requestId = manager.requestImageForAsset(asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, result in
				if cancelled {
					return
				}

				completion(image)
			}

			return {
				if !cancelled {
					cancelled = true
					manager.cancelImageRequest(requestId)
				}
			}
		}
	}
}


public func == (a: ImageView.PHAssetSource, b: ImageView.PHAssetSource) -> Bool {
	return a.asset == b.asset && a.contentMode == b.contentMode && a.targetSize == b.targetSize
}

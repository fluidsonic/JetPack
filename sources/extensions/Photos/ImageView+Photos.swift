// TODO
// - allow passing PHImageRequestOptions, copy it and set .synchronous to false
// - allow using a custom PHImageManager, e.g. PHCachingImageManager

import Photos
import UIKit


public extension ImageView {

	public struct PHAssetSource: Source {

		var asset: PHAsset
		var contentMode: PHImageContentMode
		var targetSize: CGSize


		public init(asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode) {
			self.asset = asset
			self.contentMode = contentMode
			self.targetSize = targetSize
		}


		public func retrieveImageForImageView(imageView: ImageView, completion: UIImage? -> Void) -> (Void -> Void) {
			let manager = PHImageManager.defaultManager()
			let options = PHImageRequestOptions()
			options.deliveryMode = .Opportunistic
			options.networkAccessAllowed = true
			options.resizeMode = .Exact
			options.synchronous = false
			options.version = .Current

			let requestId = manager.requestImageForAsset(asset, targetSize: targetSize, contentMode: contentMode, options: options) { image, result in
				if let cancelled = result?[PHImageCancelledKey] as? Bool where cancelled {
					return
				}

				completion(image)
			}

			return {
				manager.cancelImageRequest(requestId)
			}
		}
	}
}

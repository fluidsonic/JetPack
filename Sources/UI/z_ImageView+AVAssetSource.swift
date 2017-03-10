// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import AVFoundation
import UIKit


public extension ImageView {

	public struct AVAssetSource: Source, Equatable {

		public var asset: AVAsset
		public var videoComposition: AVVideoComposition?


		public init(asset: AVAsset) {
			self.asset = asset
		}


		public func createSession() -> Session? {
			return AVAssetSourceSession(asset: asset, videoComposition: videoComposition)
		}
	}
}


public func == (a: ImageView.AVAssetSource, b: ImageView.AVAssetSource) -> Bool {
	return a.asset == b.asset
}



private final class AVAssetSourceSession: ImageView.Session {

	fileprivate let generator: AVAssetImageGenerator
	fileprivate var lastRequestedSize = CGSize()
	fileprivate var listener: ImageView.SessionListener?
	fileprivate var loading = false


	fileprivate init(asset: AVAsset, videoComposition: AVVideoComposition?) {
		generator = AVAssetImageGenerator(asset: asset)
		generator.appliesPreferredTrackTransform = true
		generator.videoComposition = videoComposition
	}


	fileprivate func imageViewDidChangeConfiguration(_ imageView: ImageView) {
		startOrRestartRequestForImageView(imageView)
	}


	fileprivate func startOrRestartRequestForImageView(_ imageView: ImageView) {
		let optimalSize = imageView.optimalImageSize.scaleBy(imageView.optimalImageScale)
		var size = self.lastRequestedSize
		size.width = max(size.width, optimalSize.width, size.height, optimalSize.height)
		size.height = size.width

		guard size != lastRequestedSize else {
			return
		}

		stopRequest()
		startRequestWithSize(size)
	}


	fileprivate func startRequestWithSize(_ size: CGSize) {
		precondition(!loading)

		self.lastRequestedSize = size

		generator.maximumSize = size
		loading = true

		let times = [NSValue(time: CMTimeMakeWithSeconds(0, 1000))]

		generator.generateCGImagesAsynchronously(forTimes: times) { _, cgImage, _, _, _ in
			guard let cgImage = cgImage else {
				return
			}

			let image = UIImage(cgImage: cgImage)
			let imageSize = image.size.scaleBy(image.scale)

			self.lastRequestedSize.width = max(self.lastRequestedSize.width, imageSize.width)
			self.lastRequestedSize.height = max(self.lastRequestedSize.height, imageSize.height)

			onMainQueue {
				self.listener?.sessionDidRetrieveImage(image)
			}
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
		guard loading else {
			return
		}

		generator.cancelAllCGImageGeneration()
		loading = false
	}
}

// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import AVFoundation
import UIKit


public extension ImageView {

	public struct AVAssetSource: Source, Equatable {

		public var asset: AVAsset


		public init(asset: AVAsset) {
			self.asset = asset
		}


		public func createSession() -> Session? {
			return AVAssetSourceSession(asset: asset)
		}


		public var staticImage: UIImage? {
			return nil
		}
	}
}


public func == (a: ImageView.AVAssetSource, b: ImageView.AVAssetSource) -> Bool {
	return a.asset == b.asset
}



private final class AVAssetSourceSession: ImageView.Session {

	private let generator: AVAssetImageGenerator
	private var lastRequestedSize = CGSize()
	private var listener: ImageView.SessionListener?
	private var loading = false


	private init(asset: AVAsset) {
		generator = AVAssetImageGenerator(asset: asset)
		generator.appliesPreferredTrackTransform = true
	}


	private func imageViewDidChangeConfiguration(imageView: ImageView) {
		startOrRestartRequestForImageView(imageView)
	}


	private func startOrRestartRequestForImageView(imageView: ImageView) {
		let optimalSize = imageView.optimalImageSize
		var size = self.lastRequestedSize
		size.width = max(size.width, optimalSize.width, size.height, optimalSize.height)
		size.height = size.width

		guard size != lastRequestedSize else {
			return
		}

		stopRequest()
		startRequestWithSize(size)
	}


	private func startRequestWithSize(size: CGSize) {
		precondition(!loading)

		self.lastRequestedSize = size

		generator.maximumSize = size
		loading = true

		let times = [NSValue(CMTime: CMTimeMakeWithSeconds(0, 1000))]

		generator.generateCGImagesAsynchronouslyForTimes(times) { _, cgImage, _, _, _ in
			guard let cgImage = cgImage else {
				return
			}

			let image = UIImage(CGImage: cgImage)
			let imageSize = image.size.scaleBy(image.scale)

			self.lastRequestedSize.width = max(self.lastRequestedSize.width, imageSize.width)
			self.lastRequestedSize.height = max(self.lastRequestedSize.height, imageSize.height)

			onMainQueue {
				self.listener?.sessionDidRetrieveImage(image)
			}
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
		guard loading else {
			return
		}

		generator.cancelAllCGImageGeneration()
		loading = false
	}
}

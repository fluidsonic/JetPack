// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import UIKit


public extension ImageView {

	public struct UrlSource: ImageView.Source, Equatable {

		public let isTemplate: Bool
		public let url: NSURL


		public init(url: NSURL, isTemplate: Bool = false) {
			self.isTemplate = isTemplate
			self.url = url
		}


		public func createSession() -> ImageView.Session? {
			return UrlSourceSession(source: self)
		}


		public var staticImage: UIImage? {
			return nil
		}
	}
}


public func == (a: ImageView.UrlSource, b: ImageView.UrlSource) -> Bool {
	return a.url == b.url && a.isTemplate == b.isTemplate
}



private final class UrlSourceSession: ImageView.Session {

	private let source: ImageView.UrlSource
	private var stopDownload: Closure?


	private init(source: ImageView.UrlSource) {
		self.source = source
	}


	private func imageViewDidChangeConfiguration(imageView: ImageView) {
		// ignore
	}


	private func startRetrievingImageForImageView(imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(stopDownload == nil)

		stopDownload = ImageDownloader.forUrl(source.url).download { (var image) in
			if self.source.isTemplate {
				image = image.imageWithRenderingMode(.AlwaysTemplate)
			}

			listener.sessionDidRetrieveImage(image)
		}
	}


	private func stopRetrievingImage() {
		guard let stopDownload = stopDownload else {
			return
		}

		self.stopDownload = nil

		stopDownload()
	}
}



private final class ImageCache {

	private let cache = NSCache()


	private init() {}


	private func costForImage(image: UIImage) -> Int {
		// TODO does CGImageGetHeight() include the scale?
		return CGImageGetBytesPerRow(image.CGImage) * CGImageGetHeight(image.CGImage)
	}


	private func imageForKey(key: AnyObject) -> UIImage? {
		return cache.objectForKey(key) as? UIImage
	}


	private func setImage(image: UIImage, forKey key: AnyObject) {
		cache.setObject(image, forKey: key, cost: costForImage(image))
	}


	private static let sharedInstance = ImageCache()
}



private final class ImageDownloader {

	private typealias Completion = UIImage -> Void

	private static var downloaders = [NSURL : ImageDownloader]()

	private var completions = [Int : Completion]()
	private var image: UIImage?
	private var nextId = 0
	private var task: NSURLSessionDataTask?
	private let url: NSURL


	private init(url: NSURL) {
		self.url = url
	}


	private func cancelCompletionWithId(id: Int) {
		completions[id] = nil

		if completions.isEmpty {
			onMainQueue { // wait one cycle. maybe someone canceled just to retry immediately
				if self.completions.isEmpty {
					self.cancelDownload()
				}
			}
		}
	}


	private func cancelDownload() {
		precondition(completions.isEmpty)

		task?.cancel()
		task = nil
	}


	private func download(completion: Completion) -> CancelClosure {
		if let image = image {
			completion(image)
			return {}
		}

		if let image = ImageCache.sharedInstance.imageForKey(url) {
			self.image = image

			runAllCompletions()
			cancelDownload()

			completion(image)
			return {}
		}

		let id = nextId++
		completions[nextId] = completion

		startDownload()

		return {
			self.cancelCompletionWithId(id)
		}
	}


	private static func forUrl(url: NSURL) -> ImageDownloader {
		if let downloader = downloaders[url] {
			return downloader
		}

		let downloader = ImageDownloader(url: url)
		downloaders[url] = downloader

		return downloader
	}


	private func runAllCompletions() {
		guard let image = image else {
			fatalError("Cannot run completions unless an image was successfully loaded")
		}

		// careful: a completion might get removed while we're calling another one so don't copy the dictionary
		while let (id, completion) = self.completions.first {
			self.completions.removeValueForKey(id)
			completion(image)
		}

		ImageDownloader.downloaders[url] = nil
	}


	private func startDownload() {
		precondition(image == nil)
		precondition(!completions.isEmpty)

		guard self.task == nil else {
			return
		}

		let url = self.url
		let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
			guard let data = data, image = UIImage(data: data) else {
				onMainQueue {
					self.task = nil
				}

				var failureReason: String
				if let error = error {
					failureReason = "\(error)"
				}
				else {
					failureReason = "server returned invalid response or image could not be parsed"
				}

				log("Cannot load image '\(url)': \(failureReason)")

				// TODO retry, handle 4xx, etc.
				return
			}

			image.inflate() // TODO doesn't UIImage(data:) already inflate the image?
			
			onMainQueue {
				self.task = nil
				self.image = image
				
				self.runAllCompletions()
			}
		}
		
		self.task = task
		task.resume()
	}
}

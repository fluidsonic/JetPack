// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import ImageIO
import UIKit


public extension ImageView {

	public struct UrlSource: ImageView.Source, Equatable {

		public var considersOptimalImageSize = true
		public var isTemplate: Bool
		public var url: URL


		public init(url: URL, isTemplate: Bool = false) {
			self.isTemplate = isTemplate
			self.url = url
		}


		public static func cachedImageForUrl(_ url: URL) -> UIImage? {
			return ImageCache.sharedInstance.imageForKey(url as AnyObject)
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

	fileprivate let source: ImageView.UrlSource
	fileprivate var stopLoading: Closure?


	fileprivate init(source: ImageView.UrlSource) {
		self.source = source
	}


	fileprivate func imageViewDidChangeConfiguration(_ imageView: ImageView) {
		// ignore
	}


	fileprivate func startRetrievingImageForImageView(_ imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(stopLoading == nil)

		func completion(image sourceImage: UIImage) {
			var image = sourceImage
			if self.source.isTemplate {
				image = image.withRenderingMode(.alwaysTemplate)
			}

			listener.sessionDidRetrieveImage(image)
		}

		if source.url.isFileURL && source.considersOptimalImageSize {
			let optimalImageSize = imageView.optimalImageSize
			stopLoading = ImageFileLoader.forUrl(source.url, size: max(optimalImageSize.width, optimalImageSize.height)).load(completion)
		}
		else {
			stopLoading = ImageDownloader.forUrl(source.url).download(completion)
		}
	}


	fileprivate func stopRetrievingImage() {
		guard let stopLoading = stopLoading else {
			return
		}

		self.stopLoading = nil

		stopLoading()
	}
}



private final class ImageCache {

	fileprivate let cache = NSCache<AnyObject, AnyObject>()


	fileprivate init() {}


	fileprivate func costForImage(_ image: UIImage) -> Int {
		guard let cgImage = image.cgImage else {
			return 0
		}

		// TODO does CGImageGetHeight() include the scale?
		return cgImage.bytesPerRow * cgImage.height
	}


	fileprivate func imageForKey(_ key: AnyObject) -> UIImage? {
		return cache.object(forKey: key) as? UIImage
	}


	fileprivate func setImage(_ image: UIImage, forKey key: AnyObject) {
		cache.setObject(image, forKey: key, cost: costForImage(image))
	}


	fileprivate static let sharedInstance = ImageCache()
}



private final class ImageDownloader {

	fileprivate typealias Completion = (UIImage) -> Void

	fileprivate static var downloaders = [URL : ImageDownloader]()

	fileprivate var completions = [Int : Completion]()
	fileprivate var image: UIImage?
	fileprivate var nextId = 0
	fileprivate var task: URLSessionDataTask?
	fileprivate let url: URL


	fileprivate init(url: URL) {
		self.url = url
	}


	fileprivate func cancelCompletionWithId(_ id: Int) {
		completions[id] = nil

		if completions.isEmpty {
			onMainQueue { // wait one cycle. maybe someone canceled just to retry immediately
				if self.completions.isEmpty {
					self.cancelDownload()
				}
			}
		}
	}


	fileprivate func cancelDownload() {
		precondition(completions.isEmpty)

		task?.cancel()
		task = nil
	}


	fileprivate func download(_ completion: @escaping Completion) -> CancelClosure {
		if let image = image {
			completion(image)
			return {}
		}

		if let image = ImageCache.sharedInstance.imageForKey(url as AnyObject) {
			self.image = image

			runAllCompletions()
			cancelDownload()

			completion(image)
			return {}
		}

		let id = nextId
		nextId += 1

		completions[id] = completion

		startDownload()

		return {
			self.cancelCompletionWithId(id)
		}
	}


	fileprivate static func forUrl(_ url: URL) -> ImageDownloader {
		if let downloader = downloaders[url] {
			return downloader
		}

		let downloader = ImageDownloader(url: url)
		downloaders[url] = downloader

		return downloader
	}


	fileprivate func runAllCompletions() {
		guard let image = image else {
			fatalError("Cannot run completions unless an image was successfully loaded")
		}

		// careful: a completion might get removed while we're calling another one so don't copy the dictionary
		while let (id, completion) = self.completions.first {
			self.completions.removeValue(forKey: id)
			completion(image)
		}

		ImageDownloader.downloaders[url] = nil
	}


	fileprivate func startDownload() {
		precondition(image == nil)
		precondition(!completions.isEmpty)

		guard self.task == nil else {
			return
		}

		let url = self.url
		let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
			guard let data = data, let image = UIImage(data: data) else {
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

				ImageCache.sharedInstance.setImage(image, forKey: url as AnyObject)
				
				self.runAllCompletions()
			}
		}) 
		
		self.task = task
		task.resume()
	}
}



private final class ImageFileLoader {

	fileprivate typealias Completion = (UIImage) -> Void

	fileprivate static var loaders = [Query : ImageFileLoader]()
	fileprivate static let operationQueue = OperationQueue()

	fileprivate var completions = [Int : Completion]()
	fileprivate var image: UIImage?
	fileprivate var nextId = 0
	fileprivate var operation: Operation?
	fileprivate let query: Query


	fileprivate init(query: Query) {
		self.query = query
	}


	fileprivate func cancelCompletionWithId(_ id: Int) {
		completions[id] = nil

		if completions.isEmpty {
			onMainQueue { // wait one cycle. maybe someone canceled just to retry immediately
				if self.completions.isEmpty {
					self.cancelOperation()
				}
			}
		}
	}


	fileprivate func cancelOperation() {
		precondition(completions.isEmpty)

		operation?.cancel()
		operation = nil
	}


	fileprivate func load(_ completion: @escaping Completion) -> CancelClosure {
		if let image = image {
			completion(image)
			return {}
		}

		if let image = ImageCache.sharedInstance.imageForKey(query) {
			self.image = image

			runAllCompletions()
			cancelOperation()

			completion(image)
			return {}
		}

		let id = nextId
		nextId += 1

		completions[id] = completion

		startOperation()

		return {
			self.cancelCompletionWithId(id)
		}
	}


	fileprivate static func forUrl(_ url: URL, size: CGFloat) -> ImageFileLoader {
		let query = Query(url: url, size: size)

		if let loader = loaders[query] {
			return loader
		}

		let loader = ImageFileLoader(query: query)
		loaders[query] = loader

		return loader
	}


	fileprivate func runAllCompletions() {
		guard let image = image else {
			fatalError("Cannot run completions unless an image was successfully loaded")
		}

		// careful: a completion might get removed while we're calling another one so don't copy the dictionary
		while let (id, completion) = self.completions.first {
			self.completions.removeValue(forKey: id)
			completion(image)
		}

		ImageFileLoader.loaders[query] = nil
	}


	fileprivate func startOperation() {
		precondition(image == nil)
		precondition(!completions.isEmpty)

		guard self.operation == nil else {
			return
		}

		let query = self.query
		let size = query.size
		let url = query.url

		let operation = BlockOperation() {
			var image: UIImage?
			defer {
				onMainQueue {
					self.operation = nil
					self.image = image

					guard let image = image else {
						return
					}

					ImageCache.sharedInstance.setImage(image, forKey: query)
					self.runAllCompletions()
				}
			}

			guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
				log("Cannot load image '\(url)': Cannot create image source")
				return
			}

			let options: [AnyHashable: Any] = [
				kCGImageSourceCreateThumbnailFromImageAlways as AnyHashable: kCFBooleanTrue,
				kCGImageSourceCreateThumbnailWithTransform as AnyHashable:   kCFBooleanTrue,
				kCGImageSourceThumbnailMaxPixelSize as AnyHashable:          size
			]

			guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary?) else {
				log("Cannot load image '\(url)': Cannot create thumbnail from image source")
				return
			}

			image = UIImage(cgImage: cgImage)
			image?.inflate()
		}
		
		self.operation = operation
		ImageFileLoader.operationQueue.addOperation(operation)
	}



	fileprivate final class Query: NSObject {

		fileprivate let size: CGFloat
		fileprivate let url:  URL


		fileprivate init(url: URL, size: CGFloat) {
			self.size = size
			self.url = url
		}


		fileprivate override func copy() -> Any {
			return self
		}


		fileprivate override var hash: Int {
			return url.hashValue ^ size.hashValue
		}


		fileprivate override func isEqual(_ object: Any?) -> Bool {
			guard let query = object as? Query else {
				return false
			}

			return url == query.url && size == query.size
		}
	}
}

// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import ImageIO
import UIKit


public extension ImageView {

	struct UrlSource: ImageView.Source, Equatable {

		fileprivate var url: URL

		public var cacheDuration: TimeInterval?
		public var considersOptimalImageSize = true
		public var isTemplate: Bool
		public var placeholder: UIImage?


		public var urlRequest: URLRequest {
			didSet {
				guard let url = urlRequest.url else {
					preconditionFailure("urlRequest.url must not be nil")
				}

				self.url = url
			}
		}


		public init(url: URL, isTemplate: Bool = false, placeholder: UIImage? = nil, cacheDuration: TimeInterval? = nil) {
			self.init(urlRequest: URLRequest(url: url), isTemplate: isTemplate, placeholder: placeholder, cacheDuration: cacheDuration)
		}


		public init(urlRequest: URLRequest, isTemplate: Bool = false, placeholder: UIImage? = nil, cacheDuration: TimeInterval? = nil) {
			guard let url = urlRequest.url else {
				preconditionFailure("urlRequest.url must not be nil")
			}

			self.cacheDuration = cacheDuration
			self.isTemplate = isTemplate
			self.placeholder = placeholder
			self.url = url
			self.urlRequest = urlRequest
		}


		public static func cachedImage(for url: URL) -> UIImage? {
			return ImageCache.sharedInstance.image(for: url as NSURL)
		}


		public func createSession() -> ImageView.Session? {
			return UrlSourceSession(source: self)
		}


		public static func preload(url: URL, cacheDuration: TimeInterval? = nil) -> Closure {
			assert(queue: .main)

			return preload(urlRequest: URLRequest(url: url))
		}


		public static func preload(urlRequest: URLRequest, cacheDuration: TimeInterval? = nil) -> Closure {
			assert(queue: .main)

			guard urlRequest.url != nil else {
				preconditionFailure("urlRequest.url must not be nil")
			}

			return ImageDownloadCoordinator.sharedInstance.download(request: urlRequest, cacheDuration: cacheDuration) { _ in }
		}


		public static func == (a: ImageView.UrlSource, b: ImageView.UrlSource) -> Bool {
			return a.urlRequest == b.urlRequest && a.isTemplate == b.isTemplate
		}
	}
}



private final class UrlSourceSession: ImageView.Session {

	private var stopLoading: Closure?

	let source: ImageView.UrlSource


	init(source: ImageView.UrlSource) {
		self.source = source
	}


	func imageViewDidChangeConfiguration(_ imageView: ImageView) {
		// ignore
	}


	func startRetrievingImageForImageView(_ imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(stopLoading == nil)

		var isLoadingImage = true

		func completion(image sourceImage: UIImage) {
			isLoadingImage = false

			var image = sourceImage
			if self.source.isTemplate {
				image = image.withRenderingMode(.alwaysTemplate)
			}

			listener.sessionDidRetrieveImage(image)
		}

		if source.url.isFileURL && source.considersOptimalImageSize {
			let optimalImageSize = imageView.optimalImageSize.scale(by: imageView.optimalImageScale)
			stopLoading = ImageFileLoader.forURL(source.url, size: max(optimalImageSize.width, optimalImageSize.height))
				.load(completion: completion)
		}
		else {
			stopLoading = ImageDownloadCoordinator.sharedInstance.download(
				request:       source.urlRequest,
				cacheDuration: source.cacheDuration,
				completion:    completion
			)
		}

		if isLoadingImage, let placeholder = source.placeholder {
			listener.sessionDidRetrieveImage(placeholder)
		}
	}


	func stopRetrievingImage() {
		guard let stopLoading = stopLoading else {
			return
		}

		self.stopLoading = nil

		stopLoading()
	}
}



private final class ImageCache {

	private let cache = NSCache<AnyObject, UIImage>()


	private init() {}


	private func cost(for image: UIImage) -> Int {
		guard let cgImage = image.cgImage else {
			return 0
		}

		// TODO does cgImage.height include the scale?
		return cgImage.bytesPerRow * cgImage.height
	}


	func image(for key: AnyObject) -> UIImage? {
		return cache.object(forKey: key)
	}


	func set(image: UIImage, for key: AnyObject) {
		cache.setObject(image, forKey: key, cost: cost(for: image))
	}


	static let sharedInstance = ImageCache()
}



private final class ImageDownloadCoordinator: NSObject {

	typealias Completion = (UIImage) -> Void

	static let sharedInstance = ImageDownloadCoordinator()


	private let backgroundQueue = DispatchQueue.global(qos: .utility)
	private var downloadersByURL = [URL : Downloader]()
	private var downloadersByTaskId = [Int : Downloader]()

	private lazy var urlSession = URLSession(
		configuration: URLSession.shared.configuration,
		delegate:      self, // memory leak is fine, we're a shared instance with indefinite lifetime
		delegateQueue: OperationQueue.main
	)


	private override init() {
		assert(queue: .main)

		super.init()
	}


	func download(request: URLRequest, cacheDuration: TimeInterval?, completion: @escaping Completion) -> CancelClosure {
		assert(queue: .main)

		guard let url = request.url else {
			fatalError("Cannot handle URLRequest without url")
		}

		let downloader = getOrCreateDownloader(for: url)
		guard let (taskId, cancel) = downloader.download(session: urlSession, request: request, cacheDuration: cacheDuration, completion: completion) else {
			downloadersByURL[url] = nil
			return {}
		}

		downloadersByTaskId[taskId] = downloader

		return cancel
	}


	private func getOrCreateDownloader(for url: URL) -> Downloader {
		assert(queue: .main)

		if let downloader = downloadersByURL[url] {
			return downloader
		}

		let downloader = Downloader(url: url, backgroundQueue: backgroundQueue)
		downloadersByURL[url] = downloader

		return downloader
	}



	private final class Downloader {

		private let backgroundQueue: DispatchQueue
		private var cacheDuration: TimeInterval?
		private var completions = [Int : Completion]()
		private var data = Data()
		private var image: UIImage?
		private var nextRequestId = 0
		private var task: URLSessionDataTask?

		let url: URL


		init(url: URL, backgroundQueue: DispatchQueue) {
			self.backgroundQueue = backgroundQueue
			self.url = url
		}


		private func cancelCompletion(requestId: Int) {
			assert(queue: .main)

			completions[requestId] = nil

			if completions.isEmpty {
				onMainQueue { // wait one cycle. maybe someone canceled just to retry immediately
					if self.completions.isEmpty {
						self.cancelDownload()
					}
				}
			}
		}


		private func cancelDownload() {
			assert(queue: .main)

			precondition(completions.isEmpty)

			self.data.removeAll()

			task?.cancel()
			task = nil
		}


		func download(
			session: URLSession,
			request: URLRequest,
			cacheDuration: TimeInterval?,
			completion: @escaping Completion
		) -> (Int, CancelClosure)? {
			assert(queue: .main)

			if let image = image {
				completion(image)
				return nil
			}

			if let image = ImageCache.sharedInstance.image(for: url as NSURL) {
				self.image = image

				runAllCompletions()
				cancelDownload()

				completion(image)
				return nil
			}

			let requestId = nextRequestId
			nextRequestId += 1

			completions[requestId] = completion

			let taskId = startDownload(session: session, cacheDuration: cacheDuration, request: request)

			return (taskId, {
				assert(queue: .main)

				self.cancelCompletion(requestId: requestId)
			})
		}


		private func runAllCompletions() {
			assert(queue: .main)

			guard let image = image else {
				fatalError("Cannot run completions unless an image was successfully loaded")
			}

			// careful: a completion might get removed while we're calling another one so don't copy the dictionary
			while let (id, completion) = self.completions.first {
				self.completions.removeValue(forKey: id)
				completion(image)
			}
		}


		private func startDownload(session: URLSession, cacheDuration: TimeInterval?, request: URLRequest) -> Int {
			assert(queue: .main)

			precondition(image == nil)
			precondition(!completions.isEmpty)

			if let task = self.task {
				return task.taskIdentifier
			}

			self.cacheDuration = cacheDuration
			self.data.removeAll()

			let task = session.dataTask(with: request)
			self.task = task

			task.resume()

			return task.taskIdentifier
		}


		func task(_ task: URLSessionTask, didReceive data: Data) {
			assert(queue: .main)

			guard task.taskIdentifier == self.task?.taskIdentifier else {
				return
			}

			self.data.append(data)
		}


		func task(_ task: URLSessionTask, didCompleteWith error: Error?, downloaderDidFinish: @escaping Closure) {
			assert(queue: .main)

			guard task.taskIdentifier == self.task?.taskIdentifier else {
				return
			}

			let data = self.data
			self.data.removeAll()

			guard let url = task.originalRequest?.url else {
				fatalError("Cannot get original URL from task: \(task)")
			}

			if let error = error {
				// TODO retry, handle 4xx, etc.
				self.task = nil

				log("Cannot load image from '\(url)': \(error)\n\tresponse: \(task.response.map { String(describing: $0) } ?? "nil")")
				return
			}

			let cacheDuration = self.cacheDuration

			backgroundQueue.async {
				guard let image = UIImage(data: data) else {
					onMainQueue {
						self.task = nil

						log("Cannot load image from '\(url)': received data is not an image decodable by UIImage(data:)")
					}

					return
				}

				if
					cacheDuration != nil,
					let currentRequest = task.currentRequest,
					let originalRequest = task.originalRequest,
					currentRequest != originalRequest
				{
					let cache = URLCache.shared
					if let cachedResponse = cache.cachedResponse(for: currentRequest) {
						cache.storeCachedResponse(cachedResponse, for: originalRequest)
					}
				}

				image.inflate() // TODO does UIImage(data:) already inflate the image?

				onMainQueue {
					self.image = image
					self.task = nil

					ImageCache.sharedInstance.set(image: image, for: url as NSURL)

					self.runAllCompletions()

					downloaderDidFinish()
				}
			}
		}


		func task(_ task: URLSessionTask, willCache proposedResponse: CachedURLResponse) -> CachedURLResponse {
			assert(queue: .main)

			guard
				let cacheDuration = cacheDuration,
				let response = proposedResponse.response as? HTTPURLResponse,
				var headerFields = response.allHeaderFields as? [String : String],
				let url = response.url
			else {
				return proposedResponse
			}

			headerFields = headerFields.filter { key, _ in
				!ImageDownloadCoordinator.cachingHeaderFieldsNames.contains(key.lowercased())
			}
			headerFields["Cache-Control"] = "max-age=\(Int(cacheDuration.rounded()))"

			guard let newResponse = HTTPURLResponse(
				url:          url,
				statusCode:   response.statusCode,
				httpVersion:  "HTTP/1.1",
				headerFields: headerFields
			) else {
				return proposedResponse
			}

			return CachedURLResponse(
				response:      newResponse,
				data:          proposedResponse.data,
				userInfo:      proposedResponse.userInfo,
				storagePolicy: .allowed
			)
		}
	}
}


extension ImageDownloadCoordinator: URLSessionDataDelegate {

	private static let cachingHeaderFieldsNames = setOf(
		"cache-control",
		"expires",
		"pragma"
	)


	func urlSession(_ session: URLSession, dataTask task: URLSessionDataTask, didReceive data: Data) {
		assert(queue: .main)

		guard let downloader = downloadersByTaskId[task.taskIdentifier] else {
			fatalError("Cannot find downloader for task: \(task)")
		}

		downloader.task(task, didReceive: data)
	}


	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		assert(queue: .main)

		guard let downloader = downloadersByTaskId[task.taskIdentifier] else {
			fatalError("Cannot find downloader for task: \(task)")
		}

		downloadersByTaskId[task.taskIdentifier] = nil

		downloader.task(task, didCompleteWith: error) {
			assert(queue: .main)

			self.downloadersByURL[downloader.url] = nil
		}
	}


	func urlSession(
		_ session: URLSession,
		dataTask task: URLSessionDataTask,
		willCacheResponse proposedResponse: CachedURLResponse,
		completionHandler: @escaping (CachedURLResponse?) -> Void
	) {
		assert(queue: .main)

		guard let downloader = downloadersByTaskId[task.taskIdentifier] else {
			fatalError("Cannot find downloader for task: \(task)")
		}

		completionHandler(downloader.task(task, willCache: proposedResponse))
	}
}



private final class ImageFileLoader {

	typealias Completion = (UIImage) -> Void

	private static var loaders = [Query : ImageFileLoader]()
	private static let operationQueue = OperationQueue()

	private var completions = [Int : Completion]()
	private var image: UIImage?
	private var nextId = 0
	private var operation: Operation?
	private let query: Query


	private init(query: Query) {
		self.query = query
	}


	private func cancelCompletionWithId(_ id: Int) {
		completions[id] = nil

		if completions.isEmpty {
			onMainQueue { // wait one cycle. maybe someone canceled just to retry immediately
				if self.completions.isEmpty {
					self.cancelOperation()
				}
			}
		}
	}


	private func cancelOperation() {
		precondition(completions.isEmpty)

		operation?.cancel()
		operation = nil
	}


	static func forURL(_ url: URL, size: CGFloat) -> ImageFileLoader {
		let query = Query(url: url, size: size)

		if let loader = loaders[query] {
			return loader
		}

		let loader = ImageFileLoader(query: query)
		loaders[query] = loader

		return loader
	}


	func load(completion: @escaping Completion) -> CancelClosure {
		if let image = image {
			completion(image)
			return {}
		}

		if let image = ImageCache.sharedInstance.image(for: query) {
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


	private func runAllCompletions() {
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


	private func startOperation() {
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

					ImageCache.sharedInstance.set(image: image, for: query)
					self.runAllCompletions()
				}
			}

			guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
				log("Cannot load image '\(url)': Cannot create image source")
				return
			}

			let options: [AnyHashable: Any] = [
				kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue as Any,
				kCGImageSourceCreateThumbnailWithTransform:   kCFBooleanTrue as Any,
				kCGImageSourceThumbnailMaxPixelSize:          size
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



	final class Query: NSObject {

		let size: CGFloat
		let url:  URL


		init(url: URL, size: CGFloat) {
			self.size = size
			self.url = url
		}


		override func copy() -> Any {
			return self
		}


		override var hash: Int {
			return url.hashValue ^ size.hashValue
		}


		override func isEqual(_ object: Any?) -> Bool {
			guard let query = object as? Query else {
				return false
			}

			return url == query.url && size == query.size
		}
	}
}

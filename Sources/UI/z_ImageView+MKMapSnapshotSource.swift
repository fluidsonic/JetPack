// File name prefixed with z_ to avoid compiler crash related to type extensions, nested types and order of Swift source files.

import MapKit


public extension ImageView {

	struct MKMapSnapshotSource: ImageView.Source, Equatable {

		private var options: MKMapSnapshotter.Options


		public init(options: MKMapSnapshotter.Options = MKMapSnapshotter.Options()) {
			self.options = options

			ensureUniqueOptions()
		}


		public var camera: MKMapCamera {
			get { return options.camera }
			set {
				if newValue != options.camera {
					ensureUniqueOptions()
					options.camera = newValue
				}
			}
		}


		public func createSession() -> ImageView.Session? {
			return MKMapSnapshotSourceSession(options: options)
		}


		private mutating func ensureUniqueOptions() {
			if !isKnownUniquelyReferenced(&options) {
				options = options.copy() as! MKMapSnapshotter.Options
			}
		}


		public var mapRect: MKMapRect {
			get { return options.mapRect }
			set {
				if newValue != options.mapRect {
					ensureUniqueOptions()
					options.mapRect = newValue
				}
			}
		}


		public var mapType: MKMapType {
			get { return options.mapType }
			set {
				if newValue != options.mapType {
					ensureUniqueOptions()
					options.mapType = newValue
				}
			}
		}


		public var region: MKCoordinateRegion {
			get { return options.region }
			set {
				if newValue != options.region {
					ensureUniqueOptions()
					options.region = newValue
				}
			}
		}


		public var showsBuildings: Bool {
			get { return options.showsBuildings }
			set {
				if newValue != options.showsBuildings {
					ensureUniqueOptions()
					options.showsBuildings = newValue
				}
			}
		}


		public var showsPointsOfInterest: Bool {
			get { return options.showsPointsOfInterest }
			set {
				if newValue != options.showsPointsOfInterest {
					ensureUniqueOptions()
					options.showsPointsOfInterest = newValue
				}
			}
		}


		public static func == (a: MKMapSnapshotSource, b: MKMapSnapshotSource) -> Bool {
			let a = a.options
			let b = b.options

			return a.camera == b.camera
				&& a.mapRect == b.mapRect
				&& a.mapType == b.mapType
				&& a.region == b.region
				&& a.showsBuildings == b.showsBuildings
				&& a.showsPointsOfInterest == b.showsPointsOfInterest
		}
	}
}



private final class MKMapSnapshotSourceSession: ImageView.Session {

	private var lastRequestedScale = CGFloat(0)
	private var lastRequestedSize = CGSize.zero
	private var listener: ImageView.SessionListener?
	private var options: MKMapSnapshotter.Options
	private var snapshotter: MKMapSnapshotter?


	init(options: MKMapSnapshotter.Options) {
		self.options = options
	}


	func imageViewDidChangeConfiguration(_ imageView: ImageView) {
		startOrRestartRequest(for: imageView)
	}


	private func startOrRestartRequest(for imageView: ImageView) {
		let scale = imageView.optimalImageScale
		let size = imageView.optimalImageSize

		guard scale != lastRequestedScale || size != lastRequestedSize else {
			return
		}

		stopRequest()
		startRequest(size: size, scale: scale)
	}


	private func startRequest(size: CGSize, scale: CGFloat) {
		precondition(self.snapshotter == nil)

		self.lastRequestedScale = scale
		self.lastRequestedSize = size

		options.scale = scale
		options.size = size

		let snapshotter = MKMapSnapshotter(options: options)
		self.snapshotter = snapshotter

		snapshotter.start { snapshot, _ in
			self.snapshotter = nil

			guard let snapshot = snapshot else {
				return
			}

			onMainQueue {
				self.listener?.sessionDidRetrieveImage(snapshot.image)
			}
		}
	}


	func startRetrievingImageForImageView(_ imageView: ImageView, listener: ImageView.SessionListener) {
		precondition(self.listener == nil)

		self.listener = listener

		self.startOrRestartRequest(for: imageView)
	}


	private func stopRequest() {
		guard let snapshotter = self.snapshotter else {
			return
		}

		snapshotter.cancel()
		self.snapshotter = nil
	}


	func stopRetrievingImage() {
		listener = nil

		stopRequest()
	}
}

import UIKit
import WebKit


@objc(JetPack_WebViewController)
open class WebViewController: ViewController {

	fileprivate lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

	fileprivate var initialLoadingCompleted = false

	open let configuration: WKWebViewConfiguration
	open var initialUrl: URL?
	open var opensLinksExternally = false


	public init(configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
		self.configuration = configuration

		super.init()
	}


	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	deinit {
		if isViewLoaded {
			webView.removeObserver(self, forKeyPath: "loading", context: nil)
			webView.removeObserver(self, forKeyPath: "title", context: nil)
		}
	}


	open var animatesInitialLoading = false {
		didSet {
			guard animatesInitialLoading != oldValue else {
				return
			}

			if !animatesInitialLoading && isViewLoaded {
				webView.alpha = 1
				webView.isUserInteractionEnabled = true
			}
		}
	}


	fileprivate func createWebView() -> WKWebView {
		let child = WKWebView(frame: .zero, configuration: configuration)
		child.navigationDelegate = self
		child.uiDelegate = self

		return child
	}


	open func handleEmailLink(_ link: URL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.shared.openURL(link)
		return true
	}


	open func handleLink(_ link: URL, newWindowRequested: Bool) -> Bool {
		guard let scheme = link.scheme else {
			return handleUnknownLink(link)
		}

		switch scheme {
		case "http", "https":    return handleWebLink(link, newWindowRequested: newWindowRequested)
		case "mailto":           return handleEmailLink(link)
		case "tel", "telprompt": return handlePhoneLink(link)
		default:                 return handleUnknownLink(link)
		}
	}


	open func handlePhoneLink(_ link: URL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.shared.openURL(link)
		return true
	}


	open func handleUnknownLink(_ link: URL) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.shared.openURL(link)
		return true
	}


	open func handleWebLink(_ link: URL, newWindowRequested: Bool) -> Bool {
		guard opensLinksExternally else {
			return false
		}

		UIApplication.shared.openURL(link)
		return true
	}


	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if object as? WKWebView === webView, let keyPath = keyPath {
			switch keyPath {
			case "loading", "title":
				if updatesTitleFromDocument {
					updateTitleFromDocument()
				}

			default:
				break
			}
		}
	}


	fileprivate func setUp() {
		view.backgroundColor = .white

		setUpWebView()
		setUpActivityIndicator()
	}


	fileprivate func setUpActivityIndicator() {
		let child = activityIndicator
		child.startAnimating()
	}


	fileprivate func setUpWebView() {
		webView.addObserver(self, forKeyPath: "loading", options: [], context: nil)
		webView.addObserver(self, forKeyPath: "title", options: [], context: nil)

		if updatesTitleFromDocument {
			updateTitleFromDocument()
		}

		view.addSubview(webView)
	}


	fileprivate func updateTitleFromDocument() {
		title = webView.title?.nonEmpty ?? (webView.isLoading ? "Loading…" : "") // FIXME l10n
	}


	open var updatesTitleFromDocument = false {
		didSet {
			guard updatesTitleFromDocument != oldValue else {
				return
			}

			if updatesTitleFromDocument && isViewLoaded {
				updateTitleFromDocument()
			}
		}
	}


	open override func viewDidLayoutSubviewsWithAnimation(_ animation: Animation?) {
		super.viewDidLayoutSubviewsWithAnimation(animation)

		let bounds = view.bounds

		animation.runAlways {
			var innerDecorationInsets = self.innerDecorationInsets

			// WKWebView always insets by the full keyboard height, even if it's not or just partially covered :(
			if Keyboard.isVisible {
				innerDecorationInsets.bottom = 0
			}

			// WKWebView doesn't properly support non-zero scrollView.contentInset at the moment causing .contentSize to be too large.
			var webViewFrame = bounds.insetBy(innerDecorationInsets)

			// WKWebView rounds up it's scollView's contentSize no matter what the display scale is.
			// That means the user would be able to scroll for less than a point even if they shouldn't be able to scroll at all in that axis.
			webViewFrame.height = ceil(webViewFrame.height)
			webViewFrame.width = ceil(webViewFrame.width)
			webView.frame = webViewFrame

			//webView.scrollView.scrollIndicatorInsets = outerDecorationInsets.increaseBy(innerDecorationInsets.inverse)

			if activityIndicator.superview != nil {
				var activityIndicatorFrame = CGRect()
				activityIndicatorFrame.size = activityIndicator.sizeThatFits()
				activityIndicatorFrame.center = bounds.insetBy(innerDecorationInsets).center
				activityIndicator.frame = view.alignToGrid(activityIndicatorFrame)
			}
		}
	}


	open override func viewDidLoad() {
		super.viewDidLoad()

		setUp()
	}


	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let initialUrl = initialUrl {
			self.initialUrl = nil

			if webView.url == nil && !webView.isLoading {
				let navigation = webView.load(URLRequest(url: initialUrl))
				if navigation != nil {
					initialLoadingCompleted = false

					if animatesInitialLoading {
						webView.alpha = 0
						webView.isUserInteractionEnabled = false

						view.addSubview(activityIndicator)
					}
				}
			}
		}
	}


	open fileprivate(set) lazy var webView: WKWebView = self.createWebView()
}


extension WebViewController: WKNavigationDelegate {

	open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
			decisionHandler(handleLink(url, newWindowRequested: navigationAction.targetFrame == nil) ? .cancel : .allow)
			return
		}

		decisionHandler(.allow)
	}


	open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
		if !initialLoadingCompleted {
			initialLoadingCompleted = true

			if animatesInitialLoading {
				Animation(duration: 0.5).runWithCompletion { complete in
					webView.alpha = 1
					webView.isUserInteractionEnabled = true

					activityIndicator.alpha = 0

					complete { _ in
						self.activityIndicator.removeFromSuperview()
					}
				}
			}
		}
	}
}


extension WebViewController: WKUIDelegate {}

//
//  WKWebController
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import UIKit
import WebKit

open class WKWebController: UIViewController {
    open var backNeedRefresh:Bool = false
    open var handlers:[WKWebHandler] = []
    
    public func scriptHandler<T:Codable>(_ name:String, action: @escaping (_ body:T) -> Void) {
        handlers.append(WKWebHandler(name, action: action))
    }
    
    open weak var delegate:WKDelegate?
    open weak var webView:WKWebView?
    
    private lazy var _manager = WKWebManager(self)
    private weak var _progressView:UIProgressView?
    
    public var tintColor: UIColor? {
        didSet {
            if isViewLoaded {
                _progressView?.tintColor = tintColor
                view?.tintColor = tintColor
            }
        }
    }
    
    open func appOpen(url:URL) {
        _manager.appOpen(url: url)
    }
    
    open override func loadView() {
        super.loadView()
        
        view.tintColor = tintColor
        
        let width = view.frame.width
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = tintColor
        _progressView = progressView
        progressView.frame = CGRect(x: 0, y: 0, width: width, height: 2)
        progressView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressView) {
            $0 += progressView.anchor.leading  == $0.anchor.leading
            $0 += progressView.anchor.trailing == $0.anchor.trailing
            $0 += progressView.anchor.top      == $0.anchor.top
            $0 += progressView.anchor.height   == 2
        }
        
        let config = WKWebViewConfiguration()
        let userContent = delegate?.userContentController ?? WKUserContentController()
        
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        let manager = _manager
        let errorHandler = WKWebHandler("error") {
            [weak manager] (text:String) -> Void in
            manager?.onJavaScriptError(message: text)
        }
        let shareHandler = WKWebHandler("share") {
            [weak manager] (share:ShareParams) -> Void in
            manager?.onJavaScriptShare(share)
        }
        let goAppHandler = WKWebHandler("goApp", javaScript:"""
        function iOS_make_goApp() {
            if (arguments.length == 1) {
                window.webkit.messageHandlers.goApp
                .postMessage(arguments[0]);
            } else if (arguments.length == 0) {
                window.webkit.messageHandlers.goApp
                .postMessage(0);
            } else {
                window.webkit.messageHandlers.error
                .postMessage('返回应用参数错误');
            }
        };
        """) { [weak manager] in manager?.onJavaScriptGoApp($0) }
        
        let cookieHandler = WKWebHandler("syncCookie", javaScript:"""
        function iOS_make_syncCookie() {
            if (arguments.length == 0) {
                window.webkit.messageHandlers.syncCookie
                .postMessage({cookie:document.cookie,url:window.location.href});
            } else if (arguments.length == 1) {
                window.webkit.messageHandlers.syncCookie
                .postMessage({cookie:arguments[0],url:window.location.href});
            } else if (arguments.length == 2) {
                window.webkit.messageHandlers.syncCookie
                .postMessage({cookie:arguments[0],url:arguments[1]});
            } else {
                window.webkit.messageHandlers.error
                .postMessage('同步Cookie参数错误');
            }
        };
        """) { [weak manager] in
            let dict = $0 as! [String:String]
            if  let cookie = dict["cookie"],
                let href = dict["url"],
                let url = URL(string: href) {
                manager?.onSyncCookie(cookie, for: url)
            }
        }
        
        handlers = [errorHandler, shareHandler, goAppHandler, cookieHandler]
     
        if let customHandlers = delegate?.javaScriptHandlers {
            handlers.append(contentsOf: customHandlers)
        }
        
        var handlerJavaScript:String = "var Android = new function() {\n"
        
        for handler in handlers {
            userContent.add(handler, name: handler.name)
            handler.controller = self
            handlerJavaScript += "\tthis.\(handler.name) = iOS_make_\(handler.name);\n"
        }
        handlerJavaScript += "};\n"
        handlerJavaScript += handlers.map { $0.javaScript }.joined(separator: "\n")
        print("--------------------handlerJavaScript----------------------")
        print(handlerJavaScript)
        print("--------------------handlerJavaScript----------------------")

        let handlerUserScript = WKUserScript(source: handlerJavaScript, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContent.addUserScript(handlerUserScript)
        
        if let scripts = delegate?.userScripts {
            scripts.forEach { userContent.addUserScript($0) }
        }
        
        config.userContentController = userContent;
        
        let webView = delegate?.webView?(by: view.bounds, with: config) ?? WKWebView(frame: view.bounds, configuration: config)
        webView.uiDelegate = manager
        webView.navigationDelegate = manager
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.bounces = false
        self.webView = webView

        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        

        view.insertSubview(webView, belowSubview: progressView)
        
        _progressObserver = webView.observe(\.estimatedProgress) {
            [weak self] (webView, _) in
            self?.onProgressChanged(webView.estimatedProgress)
        }
        
        view += webView.anchor.top         == view.anchor.top
        view += webView.anchor.leading     == view.anchor.leading
        view += webView.anchor.trailing    == view.anchor.trailing
        view += webView.anchor.bottom      == view.anchor.bottom
    }
    
    deinit {
        webView?.stopLoading()
        webView?.removeFromSuperview()
        _progressTimer?.cancel()
        _progressTimer = nil
        _progressObserver = nil
    }

    private var _progressObserver:NSKeyValueObservation?
    private var _progressTimer:DispatchSourceTimer?
    private var _progressOffset:Double = 0
    private var _isURLSyncCookie:Bool = false
    
    open var url:URL? {
        didSet {
            if url != oldValue {
                _isURLSyncCookie = false
            }
        }
    }
    
    private func onProgressChanged(_ progress:Double) {
        
        _progressTimer?.cancel()
        
        if progress >= 1 {
            _progressView?.isHidden = true
            _progressView?.setProgress(0, animated: false)
            _progressOffset = 0
            _progressTimer = nil
        } else {
            let web = webView
            let value = Float(progress + _progressOffset)
            DispatchQueue.main.async { [weak self] in
                self?._progressView?.isHidden = false
                self?._progressView?.setProgress(value, animated: true)
            }
//            _progressView?.setProgress(, animated: true)
            _progressOffset += 0.002
            _progressTimer = DispatchSource.makeTimerSource() //.makeTimerSource(flags: [], queue: .main)
            _progressTimer!.schedule(deadline: .now() + 0.1)
            _progressTimer!.setEventHandler { [weak web, weak self] in
                DispatchQueue.main.async { [weak web, weak self] in
                    self?.onProgressChanged(web?.estimatedProgress ?? 1)
                }
            }
            _progressTimer!.resume()
        }
    }

    func syncCookie(by url:URL) {
        _manager.save(cookies: HTTPCookieStorage.shared.cookies(for: url) ?? [])
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if !_isURLSyncCookie, let startURL = url {
            syncCookie(by: startURL)
            _isURLSyncCookie = true
        }
        
        if let startURL = url {
            webView?.load(startURL)
        }
    }

}





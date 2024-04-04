//
//  WKWebView
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit
import WebKit

private var kCurrentLoadURL = "current.load.url"

extension WKWebView {
    
    @discardableResult
    func load(_ request:URLRequest, use cookies:[HTTPCookie]) -> WKNavigation! {
        var request = request
        
        let userController = configuration.userContentController
        let scripts = userController.userScripts.filter {
            !$0.source.hasPrefix("document.cookie=")
        }
        userController.removeAllUserScripts()
        scripts.forEach { userController.addUserScript($0) }
        
        if cookies.count > 0 {
            var htmlCookies:String = ""
            var textCookies:String = ""
            for cookie in cookies {
                textCookies += "\(cookie.name)=\(cookie.value);"
                htmlCookies += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path);"
                if let date = cookie.expiresDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss 'GMT'"
                    formatter.locale = Locale(identifier: "en_US")
                    htmlCookies += " expires=\(formatter.string(from: date));';"
                } else {
                    htmlCookies += "';"
                }
            }
            userController.addUserScript(WKUserScript(source: htmlCookies, injectionTime: .atDocumentStart, forMainFrameOnly: false))
            request.setValue(textCookies, forHTTPHeaderField: "Cookie")
        } else {
            request.setValue(nil, forHTTPHeaderField: "Cookie")
        }
        
        objc_setAssociatedObject(self,(kCurrentLoadURL), request.url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        return load(request)
    }
    
    func load(_ url:URL) {
        if let manager = navigationDelegate as? WKWebManager {
            let cookies = manager.cookies(for: url)
            load(URLRequest(url: url), use: cookies)
        }
    }

}

class WKWebManager: NSObject, WKUIDelegate, WKNavigationDelegate {
    
    init(_ webController:WKWebController) {
        controller = webController
    }
    
    weak var controller:WKWebController?
    var delegate:WKDelegate? { return controller?.delegate }
    var cookieStorage:[HTTPCookie] = []
    
    func save(cookies:[HTTPCookie]) {
        cookieStorage.append(contentsOf: cookies)
    }
    
    func cookies(for url:URL) -> [HTTPCookie] {
        let host = url.host ?? ""
        let path = url.path
        let now = Date()
        return cookieStorage.filter {
            host.hasSuffix($0.domain) &&
            path.hasPrefix($0.path) &&
            ($0.expiresDate == nil || $0.expiresDate! < now)
        }
    }
    
    // MARK: - JavaScriptHandler
    func onSyncCookie(_ value:String, for url:URL) {
        save(cookies: HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie":value], for: url))
        print("==sync cookies==>", value, url)
    }
    
    func onJavaScriptError(message:String) {
        let block = delegate?.onJavaScriptError ?? {
            let alert = UIAlertController(title: "网页错误", message: $0, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        block(message)
    }
    
    func onJavaScriptGoApp(_ param:Any) {
        switch param {
        case let value as Int:
            controller?.backNeedRefresh = value == 1
        case let value as String:
            controller?.backNeedRefresh = value == "1"
        default: break
        }
        let block = delegate?.onJavaScriptGoApp ?? { _ in
            guard let webView = self.controller?.webView else { return }
            if  webView.canGoBack {
                webView.goBack()
            } else if let naviVC = self.controller?.navigationController {
                naviVC.popViewController(animated: true)
            } else {
                self.controller?.dismiss(animated: true, completion: nil)
            }
        }
        block(param)
    }
    
    func onJavaScriptShare(_ share:ShareParams) {
        delegate?.onJavaScriptShare?(share)
    }
    
    
    // MARK: - other
    func appOpen(url:URL) {
        let app = UIApplication.shared
        if !app.canOpenURL(url) { return }
        
        if "tel" == url.scheme, 10 > Double(UIDevice.current.systemVersion) ?? 0 {
            let alert = UIAlertController(title: nil, message: (url as NSURL).resourceSpecifier, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "呼叫", style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        app.open(url)
    }
    
    // MARK: - WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let block = delegate?.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:) ?? { _,_,_,_ in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { _ in
                completionHandler()
            }))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        block(webView, message, frame, completionHandler)
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let block = delegate?.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:) ?? { _,_,_,_ in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                completionHandler(false)
            }))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                completionHandler(true)
            }))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        block(webView, message, frame, completionHandler)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let block = delegate?.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame: completionHandler:) ?? { _,_,_,_,_ in
            let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
            alert.addTextField { $0.text = defaultText }
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                completionHandler(nil)
            }))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
                completionHandler(alert.textFields?.first?.text)
            }))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        block(webView, prompt, defaultText, frame, completionHandler)
    }
    
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView) {
        delegate?.webViewDidClose?(webView)
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        objc_setAssociatedObject(webView, (kCurrentLoadURL), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        let block = delegate?.webView(_:didFail:withError:) ?? { _,_,_ in
            let err = error as NSError
            if (error as NSError).code == -999 { return }
            guard let url = err.userInfo["NSErrorFailingURLKey"] as? URL else { return }

            let alert = UIAlertController(title: "加载失败", message: err.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "重试", style: .default, handler: { _ in
                webView.load(url)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.controller?.present(alert, animated: true, completion: nil)
        }
        block(webView, navigation, error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == 102 { return }
        let block = delegate?.webView(_:didFailProvisionalNavigation:withError:) ?? { _,_,_ in
            self.webView(webView, didFail: navigation, withError: error)
        }
        block(webView, navigation, error)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delegate?.webView?(webView, didCommit: navigation)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let block = delegate?.webView(_:didReceive:completionHandler:) ?? { _,_,_ in
            completionHandler(.performDefaultHandling, challenge.proposedCredential)
        }
        block(webView, challenge, completionHandler)
    }
    
    @available(iOS 9.0, *)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        delegate?.webViewWebContentProcessDidTerminate?(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.webView?(webView, didFinish: navigation)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse {
            
            print("==response==\(response.statusCode)===>>",
                response.url ?? "",
                response.allHeaderFields)
        }
        objc_setAssociatedObject(webView, (kCurrentLoadURL), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        var policy:WKNavigationResponsePolicy = .allow
        
        delegate?.webView?(webView, decidePolicyFor: navigationResponse) { policy = $0 }
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url ?? webView.url ?? URL(string: "about:blank")!
        print("==request==>>%@",navigationAction.navigationType, url);

        if navigationAction.targetFrame?.isMainFrame ?? true {
            switch navigationAction.navigationType {
            case .linkActivated:
                if  self.webView(webView, loadRequest: navigationAction.request) {
                    return decisionHandler(.cancel)
                }
            case .other:
                let loadURL = objc_getAssociatedObject(self,(kCurrentLoadURL)) as? URL
                if  url.absoluteString != loadURL?.absoluteString,
                    self.webView(webView, loadRequest: navigationAction.request) {
                    return decisionHandler(.cancel)
                }
            default: break
            }
        }
        
        if "tel" == url.scheme {
            appOpen(url: url)
            return decisionHandler(.cancel)
        }
        
        var policy:WKNavigationActionPolicy = .allow
        delegate?.webView?(webView, decidePolicyFor: navigationAction) { policy = $0 }
        decisionHandler(policy)
    }
    
    func webView(_ webView:WKWebView, loadRequest request:URLRequest) -> Bool {
        let loadURL = objc_getAssociatedObject(webView,(kCurrentLoadURL)) as? URL
        let url = request.url
        
        if loadURL?.host == url?.host {
            return false
        }
        let currURL = url ?? webView.url ?? URL(string: "about:blank")!
        webView.load(request, use: cookies(for: currURL))
        return true
    }
    
}

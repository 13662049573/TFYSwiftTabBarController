//
//  WKWebView
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import Foundation
import UIKit
@preconcurrency import WebKit

/// 定义关联键，用于存储URL相关信息
private let kCurrentLoadURLKey = UnsafeRawPointer(bitPattern: "current.load.url".hashValue)!

// MARK: - WKWebView扩展
extension WKWebView {
    /// 获取当前关联的URL
    fileprivate var currentAssociatedURL: URL? {
        get {
            return objc_getAssociatedObject(self, kCurrentLoadURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, kCurrentLoadURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 加载请求并设置cookies
    /// - Parameters:
    ///   - request: URL请求
    ///   - cookies: Cookie数组
    /// - Returns: WKNavigation实例
    @discardableResult
    func load(_ request: URLRequest, use cookies: [HTTPCookie]) -> WKNavigation! {
        var request = request
        
        // 获取用户脚本控制器
        let userController = configuration.userContentController
        // 过滤掉已有的cookie脚本
        let scripts = userController.userScripts.filter {
            !$0.source.hasPrefix("document.cookie=")
        }
        // 重新设置用户脚本
        userController.removeAllUserScripts()
        scripts.forEach { userController.addUserScript($0) }
        
        // 处理cookies
        if cookies.count > 0 {
            var htmlCookies: String = ""
            var textCookies: String = ""
            
            for cookie in cookies {
                // 构建cookie字符串
                textCookies += "\(cookie.name)=\(cookie.value);"
                htmlCookies += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path);"
                
                // 处理过期时间
                if let date = cookie.expiresDate {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss 'GMT'"
                    formatter.locale = Locale(identifier: "en_US")
                    htmlCookies += " expires=\(formatter.string(from: date));';"
                } else {
                    htmlCookies += "';"
                }
            }
            
            // 添加cookie脚本
            userController.addUserScript(WKUserScript(source: htmlCookies, injectionTime: .atDocumentStart, forMainFrameOnly: false))
            request.setValue(textCookies, forHTTPHeaderField: "Cookie")
        } else {
            request.setValue(nil, forHTTPHeaderField: "Cookie")
        }
        
        // 保存当前URL
        currentAssociatedURL = request.url
        
        return load(request)
    }
    
    /// 加载URL
    /// - Parameter url: 目标URL
    func load(_ url: URL) {
        if let manager = navigationDelegate as? WKWebManager {
            let cookies = manager.cookies(for: url)
            load(URLRequest(url: url), use: cookies)
        }
    }
}

// MARK: - WKWebManager
class WKWebManager: NSObject, WKUIDelegate, WKNavigationDelegate {
    
    /// 初始化方法
    /// - Parameter webController: Web控制器实例
    init(_ webController: WKWebController) {
        controller = webController
    }
    
    /// 弱引用Web控制器
    weak var controller: WKWebController?
    
    /// 代理对象
    var delegate: WKDelegate? { return controller?.delegate }
    
    /// Cookie存储数组
    var cookieStorage: [HTTPCookie] = []
    
    /// 保存Cookies
    /// - Parameter cookies: Cookie数组
    func save(cookies: [HTTPCookie]) {
        cookieStorage.append(contentsOf: cookies)
    }
    
    /// 获取指定URL的Cookies
    /// - Parameter url: 目标URL
    /// - Returns: 符合条件的Cookie数组
    func cookies(for url: URL) -> [HTTPCookie] {
        let host = url.host ?? ""
        let path = url.path
        let now = Date()
        return cookieStorage.filter {
            host.hasSuffix($0.domain) &&
            path.hasPrefix($0.path) &&
            ($0.expiresDate == nil || $0.expiresDate! < now)
        }
    }
    
    // MARK: - JavaScript处理方法
    
    /// 同步Cookie处理
    /// - Parameters:
    ///   - value: Cookie值
    ///   - url: 目标URL
    func onSyncCookie(_ value: String, for url: URL) {
        save(cookies: HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie":value], for: url))
        print("==sync cookies==>", value, url)
    }
    
    /// JavaScript错误处理
    /// - Parameter message: 错误信息
    func onJavaScriptError(message: String) {
        let block = delegate?.onJavaScriptError ?? { [weak self] message in
            let alert = UIAlertController(title: "网页错误", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel))
            self?.controller?.present(alert, animated: true)
        }
        block(message)
    }
    
    /// JavaScript返回App处理
    /// - Parameter param: 参数
    func onJavaScriptGoApp(_ param: Any) {
        switch param {
        case let value as Int:
            controller?.backNeedRefresh = value == 1
        case let value as String:
            controller?.backNeedRefresh = value == "1"
        default: break
        }
        
        let block = delegate?.onJavaScriptGoApp ?? { [weak self] _ in
            guard let self = self, let webView = self.controller?.webView else { return }
            if webView.canGoBack {
                webView.goBack()
            } else if let naviVC = self.controller?.navigationController {
                naviVC.popViewController(animated: true)
            } else {
                self.controller?.dismiss(animated: true)
            }
        }
        block(param)
    }
    
    /// JavaScript分享处理
    /// - Parameter share: 分享参数
    func onJavaScriptShare(_ share: ShareParams) {
        delegate?.onJavaScriptShare?(share)
    }
    
    // MARK: - 其他功能
    
    /// 打开App
    /// - Parameter url: 目标URL
    func appOpen(url: URL) {
        let app = UIApplication.shared
        guard app.canOpenURL(url) else { return }
        
        // 处理电话链接
        if url.scheme == "tel", 10 > Double(UIDevice.current.systemVersion) ?? 0 {
            let alert = UIAlertController(title: nil, message: (url as NSURL).resourceSpecifier, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "呼叫", style: .default) { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            controller?.present(alert, animated: true)
            return
        }
        app.open(url)
    }
    
    // MARK: - WKUIDelegate
    
    /// JavaScript警告框处理
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let block = delegate?.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:) ?? { [weak self] _,message,_,completionHandler in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel) { _ in
                completionHandler()
            })
            self?.controller?.present(alert, animated: true)
        }
        block(webView, message, frame, completionHandler)
    }
    
    /// JavaScript确认框处理
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let block = delegate?.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:) ?? { [weak self] _,message,_,completionHandler in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
                completionHandler(false)
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                completionHandler(true)
            })
            self?.controller?.present(alert, animated: true)
        }
        block(webView, message, frame, completionHandler)
    }
    
    /// JavaScript输入框处理
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let block = delegate?.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:) ?? { [weak self] _,prompt,defaultText,_,completionHandler in
            let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
            alert.addTextField { $0.text = defaultText }
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
                completionHandler(nil)
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
                completionHandler(alert.textFields?.first?.text)
            })
            self?.controller?.present(alert, animated: true)
        }
        block(webView, prompt, defaultText, frame, completionHandler)
    }
    
    /// Web视图关闭处理
    @available(iOS 9.0, *)
    func webViewDidClose(_ webView: WKWebView) {
        delegate?.webViewDidClose?(webView)
    }
    
    // MARK: - WKNavigationDelegate
    
    /// 导航失败处理
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 清除当前URL
        webView.currentAssociatedURL = nil
        
        let block = delegate?.webView(_:didFail:withError:) ?? { [weak self] webView,_,error in
            let err = error as NSError
            if err.code == -999 { return }
            guard let url = err.userInfo["NSErrorFailingURLKey"] as? URL else { return }
            
            let alert = UIAlertController(title: "加载失败", message: err.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "重试", style: .default) { _ in
                webView.load(url)
            })
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            self?.controller?.present(alert, animated: true)
        }
        block(webView, navigation, error)
    }
    
    /// 预加载失败处理
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if (error as NSError).code == 102 { return }
        let block = delegate?.webView(_:didFailProvisionalNavigation:withError:) ?? { [weak self] webView,navigation,error in
            self?.webView(webView, didFail: navigation, withError: error)
        }
        block(webView, navigation, error)
    }
    
    /// 开始加载处理
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webView?(webView, didStartProvisionalNavigation: navigation)
    }
    
    /// 收到服务器重定向处理
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        delegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
    }
    
    /// 开始接收内容处理
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delegate?.webView?(webView, didCommit: navigation)
    }
    
    /// 接收到认证挑战处理
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let block = delegate?.webView(_:didReceive:completionHandler:) ?? { _,challenge,completionHandler in
            completionHandler(.performDefaultHandling, challenge.proposedCredential)
        }
        block(webView, challenge, completionHandler)
    }
    
    /// Web内容进程终止处理
    @available(iOS 9.0, *)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        delegate?.webViewWebContentProcessDidTerminate?(webView)
    }
    
    /// 加载完成处理
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.webView?(webView, didFinish: navigation)
    }
    
    /// 导航策略处理
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url ?? webView.url ?? URL(string: "about:blank")!
        print("==request==>>", navigationAction.navigationType, url)
        
        if navigationAction.targetFrame?.isMainFrame ?? true {
            switch navigationAction.navigationType {
            case .linkActivated:
                if handleWebViewRequest(webView, request: navigationAction.request) {
                    decisionHandler(.cancel)
                    return
                }
            case .other:
                if url.absoluteString != webView.currentAssociatedURL?.absoluteString,
                   handleWebViewRequest(webView, request: navigationAction.request) {
                    decisionHandler(.cancel)
                    return
                }
            default: break
            }
        }
        
        if url.scheme == "tel" {
            appOpen(url: url)
            decisionHandler(.cancel)
            return
        }
        
        var policy: WKNavigationActionPolicy = .allow
        delegate?.webView?(webView, decidePolicyFor: navigationAction) { policy = $0 }
        decisionHandler(policy)
    }
    
    /// 处理Web视图请求
    /// - Parameters:
    ///   - webView: Web视图
    ///   - request: 请求对象
    /// - Returns: 是否需要取消当前导航
    private func handleWebViewRequest(_ webView: WKWebView, request: URLRequest) -> Bool {
        let url = request.url
        
        if webView.currentAssociatedURL?.host == url?.host {
            return false
        }
        
        let currURL = url ?? webView.url ?? URL(string: "about:blank")!
        webView.load(request, use: cookies(for: currURL))
        return true
    }
    
    /// 响应策略处理
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        // 打印响应信息
        if let response = navigationResponse.response as? HTTPURLResponse {
            print("==response==\(response.statusCode)===>>",
                  response.url ?? "",
                  response.allHeaderFields)
        }
        
        // 清除当前URL
        webView.currentAssociatedURL = nil
        
        var policy: WKNavigationResponsePolicy = .allow
        delegate?.webView?(webView, decidePolicyFor: navigationResponse) { policy = $0 }
        decisionHandler(policy)
    }
}

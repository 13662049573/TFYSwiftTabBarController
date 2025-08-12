//
//  WKWebView+Chain.swift
//  TFYSwiftCategoryUtil
//
//  Created by mi ni on 2024/10/26.
//  优化：参数安全性检查、注释补全、健壮性提升
//

import Foundation
import WebKit

@objc public extension WKWebView {
    
    struct AssociatedWKKey {
        static var confiDefault: UnsafeRawPointer = UnsafeRawPointer(bitPattern: "WKWebView+confiDefault".hashValue)!
    }
   
    /// WKWebViewConfiguration默认配置
    static var confiDefault: WKWebViewConfiguration {
        get {
            if let obj = objc_getAssociatedObject(self,  AssociatedWKKey.confiDefault) as? WKWebViewConfiguration {
                return obj
            }
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            
            let config = WKWebViewConfiguration()
            config.preferences.javaScriptCanOpenWindowsAutomatically = false
            config.defaultWebpagePreferences = preferences
        
            objc_setAssociatedObject(self,  AssociatedWKKey.confiDefault, config, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return config
        }
        set {
            objc_setAssociatedObject(self,  AssociatedWKKey.confiDefault, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// JS注入
    func addUserScript(_ source: String) {
        guard !source.isEmpty else { return }
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(userScript)
    }
    
    ///设置 Cookie 参数
    func setCookieByJavaScript(_ dic: [String: String], completionHandler: ((Any?, Error?) -> Void)? = nil){
        guard !dic.isEmpty else { completionHandler?(nil, nil); return }
        var result = ""
        dic.forEach { (key: String, value: String) in
            result = (result + "\(key)=\(value),")
        }
        self.evaluateJavaScript("document.cookie ='\(result)'", completionHandler: completionHandler)
    }
    
    ///添加 cookie的自动推送
    @available(iOS 11.0, macOS 10.13, *)
    func copyNSHTTPCookieStorageToWKHTTPCookieStore(_  handler: (() -> Void)? = nil) {
        guard let cookies = HTTPCookieStorage.shared.cookies, !cookies.isEmpty else { handler?(); return }
        let cookieStore = self.configuration.websiteDataStore.httpCookieStore

        if cookies.count == 0 {
            handler?()
            return
        }
        for cookie in cookies {
            cookieStore.setCookie(cookie) {
                if cookies.last!.isEqual(cookie) {
                    handler?()
                    return
                }
            }
        }
    }

    /// 字体改变
    static func javaScriptFromTextSizeRatio(_ ratio: CGFloat) -> String {
        let result = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(ratio)%'"
        return result
    }
    /// 字体改变
    func loadHTMLStringWithMagic(_ content: String, baseURL: URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
    
    ///此方法解决了: Web 页面包含了 ajax 请求的话，cookie 要重新处理,这个处理需要在 WKWebView 的 WKWebViewConfiguration 中进行配置。
    func loadUrl(_ urlString: String?, additionalHttpHeaders: [String: String]? = nil, isAddUserScript: Bool = true) {
        guard let urlString = urlString,
              let urlStr = urlString.removingPercentEncoding,
              let url = URL(string: urlStr) else {
            print("链接错误")
            return
        }
        
        if isAddUserScript == false {
            if let URL = URL(string: urlString) {
                var request = URLRequest(url: URL)
                additionalHttpHeaders?.forEach { (key, value) in
                    request.addValue(value, forHTTPHeaderField: key)
                }
               load(request)
            }
            return
        }
        
        let cookieSource: String = "document.cookie = 'user=\("userValue")'"
        let cookieScript = WKUserScript(source: cookieSource, injectionTime: .atDocumentStart, forMainFrameOnly: false)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(cookieScript)

        configuration.userContentController = userContentController

        var request = URLRequest(url: url)
        if let headFields = request.allHTTPHeaderFields, headFields["user"] == nil {
            request.addValue("user=\("userValue")", forHTTPHeaderField: "Cookie")
        }

        additionalHttpHeaders?.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        load(request)
    }

}


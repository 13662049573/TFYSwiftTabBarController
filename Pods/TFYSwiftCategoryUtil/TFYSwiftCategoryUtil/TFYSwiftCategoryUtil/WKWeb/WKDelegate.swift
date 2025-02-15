//
//  WKDelegate
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//

import WebKit

@objc public protocol WKDelegate : WKUIDelegate, WKNavigationDelegate {
    
    @objc optional var javaScriptHandlers:[WKWebHandler] { get }
    
    @objc optional var userContentController:WKUserContentController { get }
    
    @objc optional var userScripts:[WKUserScript] { get }
    
    @objc optional func webView(by frame:CGRect, with configuration:WKWebViewConfiguration) -> WKWebView?
    
    @objc optional func onJavaScriptError(message:String)
    
    @objc optional func onJavaScriptGoApp(_ param:Any)
    
    @objc optional func onJavaScriptShare(_ share:ShareParams)
}

@objc public class ShareParams: NSObject, Decodable {
    var title:String = ""
    var titleUrl:URL?
    var text:String?
    var url:URL?
    var comment:String?
    var imagePath:String?
}

//
//  WKWebHandler
//  TFYSwiftCategoryUtil
//
//  Created by 田风有 on 2021/5/10.
//  用途：WKWebView 与 JS 通信的桥接处理，支持参数类型自动解码、错误处理等。
//

import WebKit

// MARK: - JS注入接口
open class WKWebHandler: NSObject, WKScriptMessageHandler {
    
    private let script: String
    private let callback: (_ body: Any) -> Void
    
    open var name: String

    open var javaScript: String { return script }
    
    public weak var controller: WKWebController?

    public init(_ handle: String, javaScript: String, action: @escaping (_ body: Any) -> Void) {
        name = handle
        script = javaScript
        callback = action
    }
    
    public init(_ handle: String, action: @escaping () -> Void) {
        name = handle
        script = """
        function iOS_make_\(handle)(){
            if(arguments.length == 0){
                window.webkit.messageHandlers.\(handle).postMessage('');
            }else{
                window.webkit.messageHandlers.error.postMessage('\(handle)参数错误');
            }
        };
        """
        callback = { _ in action() }
    }
    
    public init<T: Decodable>(_ handle: String, action: @escaping (_ body: T) -> Void) {
        
        let encoder = try! WKScriptHandlerParamsEncoder()
        let _ = try! T(from: encoder)
        
        var js: String = """
        function iOS_make_\(handle)(){
            if(arguments.length == \(encoder.paramsCount)){
                window.webkit.messageHandlers.\(handle).postMessage(
        """
        switch encoder.type {
        case .array:    js += "arguments[0]"
        case .value:    js += "arguments[0]"
        case .none:     break
        case .more:
            js += "{"
            for (i, param) in encoder.params.enumerated() {
                js += """
                \n\t\t\t\(param):arguments[\(i)],
                """
            }
            if !encoder.params.isEmpty { js.removeLast() }
            js += "\n\t\t}"
        }
        js += """
        );
            }else{
                window.webkit.messageHandlers.error.postMessage('\(handle)参数错误');
            }
        };
        """
        script = js
        
        name = handle
        callback = { (body: Any) in
            do {
                let decoder = try WKScriptHandlerParamsDecoder(body)
                let value = try T(from: decoder)
                action(value)
            } catch let error {
                print("js handle[\(handle)] error body: \(body), error: \(error.localizedDescription)")
            }
        }
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 直接调用回调，因为callback的类型已经在初始化时确定
        callback(message.body)
    }
}

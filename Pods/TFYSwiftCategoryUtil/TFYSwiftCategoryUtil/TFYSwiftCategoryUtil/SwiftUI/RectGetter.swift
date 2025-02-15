import SwiftUI

/// Get the views frame in the global coordinate space
@available(iOS 13.0, *)
struct RectGetter: View {
    
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        TFYAsynce.async {
        } _: {
            self.rect = proxy.globalFrame
        }
        return Rectangle().fill(Color.clear)
    }
}

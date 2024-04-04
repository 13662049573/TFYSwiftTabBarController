import SwiftUI

@available(iOS 13.0, *)
public extension Binding where Value: Equatable {
    func onChange(_ action: @escaping (Value) -> Void) -> Self {
        .init(
            get: { wrappedValue },
            set: {
                let oldValue = wrappedValue
                wrappedValue = $0
                let newValue = wrappedValue
                if newValue != oldValue {
                    action(newValue)
                }
            }
        )
    }
    
}

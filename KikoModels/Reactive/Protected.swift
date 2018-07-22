import Foundation

final public class Protected<Value> {

    private var concurrentQueue = DispatchQueue(label: "com.kiko.Protected", attributes: .concurrent)
    private var _value: Value

    public var value: Value {
        get {
            return concurrentQueue.sync {
                return _value
            }
        }
        set {
            concurrentQueue.async(flags: .barrier) { [weak self] in
                self?._value = newValue
            }
        }
    }

    public init(_ value: Value) {
        _value = value
    }

    public func read(_ block: (Value) -> Void) {
        concurrentQueue.sync {
            block(_value)
        }
    }

    public func write(_ block: @escaping (inout Value) -> Void) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            block(&strongSelf._value)
        }
    }
}

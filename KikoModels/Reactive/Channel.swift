
import Foundation

public class Channel<Value> {

    private class Subscription {
        weak var object: AnyObject?
        private let notifyBlock: (Value) -> Void
        private let queue: DispatchQueue

        var isValid: Bool {
            return object != nil
        }

        init(object: AnyObject?, queue: DispatchQueue, notifyBlock: @escaping (Value) -> Void) {
            self.object = object
            self.queue = queue
            self.notifyBlock = notifyBlock
        }

        func notify(_ value: Value) {
            queue.async { [weak self] in
                guard let strongSelf = self, strongSelf.isValid else { return }
                strongSelf.notifyBlock(value)
            }
        }
    }

    private var subscriptions: Protected<[Subscription]> = Protected([])

    public init() {}

    public func subscribe(_ object: AnyObject?, queue: DispatchQueue = .main, notifyBlock: @escaping (Value) -> Void) {
        let subscription = Subscription(object: object, queue: queue, notifyBlock: notifyBlock)

        subscriptions.write { subscriptions in
            subscriptions.append(subscription)
        }
    }

    public func unsubscribe(_ object: AnyObject?) {
        subscriptions.write { subscriptions in
            guard let index = subscriptions.index(where: { $0.object === object }) else { return }
            subscriptions.remove(at: index)
        }
    }

    public func broadcast(_ value: Value) {
        subscriptions.write { subscriptions in
            subscriptions = subscriptions.filter { $0.isValid }
            subscriptions.forEach { $0.notify(value) }
        }
    }
}

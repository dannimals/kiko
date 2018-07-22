// https://medium.com/@RobertGummesson/regarding-swift-build-time-optimizations-fc92cdd91e31#.jaggt72x1
public func unwrapOrEmpty(_ optional: String?) -> String {
    guard let opt = optional else { return "" }
    return opt
}

public func unwrapOrEmpty(_ optional: Int?) -> Int {
    guard let opt = optional else { return 0 }
    return opt
}

public func unwrapOrElse<T>(_ optional: T?, fallback: T) -> T {
    guard let opt = optional else { return fallback }
    return opt
}

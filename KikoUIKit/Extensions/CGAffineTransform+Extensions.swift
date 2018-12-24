
extension CGAffineTransform {

    public var rotation: Double {
        return atan2(Double(b), Double(a))
    }
}

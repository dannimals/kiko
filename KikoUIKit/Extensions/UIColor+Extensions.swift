
public extension UIColor {
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            r: CGFloat((hex >> 16) & 0xff) / 255,
            g: CGFloat((hex >> 08) & 0xff) / 255,
            b: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.r, green: components.g, blue: components.b, alpha: alpha)
    }

    public static var backgroundYellow: UIColor {
        return UIColor(hex: 0xFFEEB4).withAlphaComponent(0.97)
    }

    public static var salmonPink: UIColor {
        return UIColor(hex: 0xEFADA1)
    }
}

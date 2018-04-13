
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

    public static var backgroundPurple: UIColor {
        return UIColor(hex: 0xE4E8FD)
    }

    public static var backgroundRed: UIColor {
        return UIColor(hex: 0xFFDBC4)
    }

    public static var backgroundGreen: UIColor {
        return UIColor(hex: 0xCADFBC)
    }

    public static var defaultBackground: UIColor {
        return UIColor(hex: 0xE2E7F0)
    }

    public static var salmonPink: UIColor {
        return UIColor(hex: 0xEFADA1)
    }

    public static var selectedSalmonPink: UIColor {
        return UIColor(hex: 0xAD6A5D)
    }

    public static var tealBlue: UIColor {
        return UIColor(hex: 0x36BBC6)
    }

    public static var selectedTeal: UIColor {
        return UIColor(hex: 0x3A8C93)
    }

    public static var rouge: UIColor {
        return UIColor(hex: 0xEB6F57)
    }

    public static var selectedRouge: UIColor {
        return UIColor(hex: 0xB15442)
    }

    public static var mossGreen: UIColor {
        return UIColor(hex: 0x54A03D)
    }

    public static var selectedGreen: UIColor {
        return UIColor(hex: 0x467D36)
    }

    public static var defaultAccessory: UIColor {
        return UIColor(hex: 0x9CA4CD)
    }

    public static var indicatorGrey: UIColor {
        return UIColor(hex: 0xF7F5F0).withAlphaComponent(0.97)
    }

    public static var textDarkGrey: UIColor {
        return UIColor(hex: 0x889298)
    }

    public static var textLightGrey: UIColor {
        return UIColor(hex: 0x9DAFBB)
    }

    public var faded: UIColor {
        return withAlphaComponent(0.3)
    }

}

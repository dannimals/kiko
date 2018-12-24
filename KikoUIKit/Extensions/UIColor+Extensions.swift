public extension UIColor {

    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            r: CGFloat((hex >> 16) & 0xff) / 255,
            g: CGFloat((hex >> 08) & 0xff) / 255,
            b: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.r, green: components.g, blue: components.b, alpha: alpha)
    }

    public static var backgroundBlue: UIColor {
        return UIColor(hex: 0x7CC0EF)
    }

    public static var monthResultBackground: UIColor {
        return UIColor(hex: 0xFFFFFF).withAlphaComponent(0.46)
    }
    public static var paleBlue: UIColor {
        return UIColor(hex: 0xE3F4FF)
    }
    public static var waveBlue: UIColor {
        return UIColor(hex: 0xC0A1FF)
    }
    public static var grey01: UIColor {
        return UIColor(hex: 0x80909B)
    }
    public static var grey02: UIColor {
        return UIColor(hex: 0x697278)
    }
    public static var grey03: UIColor {
        return UIColor(hex: 0x4B555C)
    }
    public static var grey04: UIColor {
        return UIColor(hex: 0xF7F5F0).withAlphaComponent(0.97)
    }
    public static var lightGreyBlue: UIColor {
        return UIColor(hex: 0x92B8D2)
    }
    public static var purple01: UIColor {
        return UIColor(hex: 0x9EB8F2)
    }
    public static var purple02: UIColor {
        return UIColor(hex: 0x9A81EC)
    }
    public static var purple03: UIColor {
        return UIColor(hex: 0xA775CD)
    }
    public static var yellow01: UIColor {
        return UIColor(hex: 0xF0CA6A)
    }
    public static var yellow02: UIColor {
        return UIColor(hex: 0xF3C768)
    }
    public static var yellow03: UIColor {
        return UIColor(hex: 0xF99D65)
    }
    public static var yellow04: UIColor {
        return UIColor(hex: 0xE48145)
    }
    public static var blue01: UIColor {
        return UIColor(hex: 0xB5DEFB)
    }
    public static var blue02: UIColor {
        return UIColor(hex: 0x8EC9F2)
    }
    public static var blue03: UIColor {
        return UIColor(hex: 0x8491E1)
    }
    public static var blue04: UIColor {
        return UIColor(hex: 0x6094E2)
    }
    public static var blue05: UIColor {
        return UIColor(hex: 0xACD4F0)
    }
    public static var red01: UIColor {
        return UIColor(hex: 0xF9C3BA)
    }
    public static var red02: UIColor {
        return UIColor(hex: 0xEFAFA1)
    }
    public static var red03: UIColor {
        return UIColor(hex: 0xF47085)
    }
    public static var red04: UIColor {
        return UIColor(hex: 0xD07886)
    }
    public static var green01: UIColor {
        return UIColor(hex: 0xA3F4C7)
    }
    public static var green02: UIColor {
        return UIColor(hex: 0x8AE3B2)
    }
    public static var green03: UIColor {
        return UIColor(hex: 0x3CB3A5)
    }
    public static var green04: UIColor {
        return UIColor(hex: 0x4EAD78)
    }

    public var faded: UIColor {
        return withAlphaComponent(0.3)
    }

}

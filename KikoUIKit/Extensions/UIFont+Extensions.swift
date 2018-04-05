
extension UIFont {

    public static func customFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var fontWeight: String
        switch weight {
        case .heavy:
            fontWeight = "Heavy"
        case .light:
            fontWeight = "Light"
        case .medium:
            fontWeight = "Medium"
        default:
            fontWeight = "Regular"
        }

        guard let font = UIFont(name: "Avenir-\(fontWeight)", size: size) else { return UIFont.systemFont(ofSize: size, weight: weight) }
        return font
    }
}

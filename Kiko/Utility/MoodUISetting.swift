import KikoUIKit

enum MoodUISetting: Int {
    case chick
    case chickEgg
    case crackingEgg
    case rottenEgg
    case unknown

    var backgroundColor: UIColor {
        switch self {
        case .chick:
            return UIColor.backgroundYellow
        case .chickEgg:
            return UIColor.backgroundPurple
        case .crackingEgg:
            return UIColor.backgroundRed
        case .rottenEgg:
            return UIColor.backgroundGreen
        case .unknown:
            return UIColor.defaultBackground
        }
    }

    var accessoryColor: UIColor {
        switch self {
        case .chick:
            return UIColor.cornflowerYellow
        case .chickEgg:
            return UIColor.tealBlue
        case .crackingEgg:
            return UIColor.salmonPink
        case .rottenEgg:
            return UIColor.mossGreen
        case .unknown:
            return UIColor.defaultAccessory
        }
    }

    var selectedAccessoryColor: UIColor {
        switch self {
        case .chick:
            return UIColor.selectedSalmonPink
        case .chickEgg:
            return UIColor.selectedTeal
        case .crackingEgg:
            return UIColor.selectedRouge
        case .rottenEgg:
            return UIColor.selectedGreen
        case .unknown:
            return UIColor.clear
        }
    }
}

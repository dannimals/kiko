
import KikoUIKit

class MoodPageViewModel {

    var pages: [MoodPageDisplayable] = []

    init() {
        setupPages()
    }

    private func setupPages() {
    pages.append(MoodPageDisplayable(moodType: .chick, image: #imageLiteral(resourceName: "chick"), primaryColor: .backgroundYellow, accessoryColor: .cornflowerYellow, selectedColor: .selectedSalmonPink))
    pages.append(MoodPageDisplayable(moodType: .chickEgg, image: #imageLiteral(resourceName: "chickEgg"), primaryColor: .backgroundPurple, accessoryColor: .tealBlue, selectedColor: .selectedTeal))
    pages.append(MoodPageDisplayable(moodType: .egg, image: #imageLiteral(resourceName: "egg"), primaryColor: .backgroundRed, accessoryColor: .salmonPink, selectedColor: .selectedRouge))
    pages.append(MoodPageDisplayable(moodType: .rottenEgg, image: #imageLiteral(resourceName: "rottenEgg"), primaryColor: .backgroundGreen, accessoryColor: .mossGreen, selectedColor: .selectedGreen))
    }
}

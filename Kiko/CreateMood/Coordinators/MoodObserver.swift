
import KikoModels

protocol MoodPagingObserving: class {

    func moodPageViewModel(_ viewModel: MoodPageViewModel, didUpdateMoodPage: MoodPageDisplayable)

    func moodPageViewDidSelectToday(_ viewModel: MoodPageViewModel)

}

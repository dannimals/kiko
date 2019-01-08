
import KikoModels
import KikoUIKit

class MoodPageViewModel {

    private var currentPage: MoodPageDisplayable = MoodPageDisplay(type: .chick)
    private(set) var pages: [MoodPageDisplayable] = []
    private var observations = [ObjectIdentifier: Observation]()

    init() {
        setupPages()
    }

    func updateCurrentPage(_ page: MoodPageDisplayable) {
        currentPage = page
        notifyObservers()
    }

    func addObserver(_ observer: MoodPagingObserving) {
        let identifier = ObjectIdentifier(observer)
        observations[identifier] = Observation(observer: observer)
        observer.moodPageViewModel(self, didUpdateMoodPage: currentPage)
    }

    private func notifyObservers() {
        observations.forEach { id, observation in
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                return
            }
            observer.moodPageViewModel(self, didUpdateMoodPage: currentPage)
        }
    }

    private func setupPages() {
        pages.append(MoodPageDisplay(type: .chick))
        pages.append(MoodPageDisplay(type: .chickEgg))
        pages.append(MoodPageDisplay(type: .egg))
        pages.append(MoodPageDisplay(type: .rottenEgg))
    }
}

extension MoodPageViewModel {
    struct Observation {
        weak var observer: MoodPagingObserving?
    }
}

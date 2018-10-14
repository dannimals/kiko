
import KikoModels
import KikoUIKit

class MoodPageViewModel {

    private var currentPage = MoodPageDisplayable(type: .chick)
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
        pages.append(MoodPageDisplayable(type: .chick))
        pages.append(MoodPageDisplayable(type: .chickEgg))
        pages.append(MoodPageDisplayable(type: .egg))
        pages.append(MoodPageDisplayable(type: .rottenEgg))
    }
}

extension MoodPageViewModel {
    struct Observation {
        weak var observer: MoodPagingObserving?
    }
}

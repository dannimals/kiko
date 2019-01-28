
import KikoModels
import KikoUIKit

enum ObserverEvent {
    case didUpdatePage
    case didSelectToday
}

class MoodPageViewModel {

    private var currentPage: MoodPageDisplayable = MoodPageDisplay(type: .chick)
    private(set) var pages: [MoodPageDisplayable] = []
    private var observations = [ObjectIdentifier: Observation]()

    init() {
        setupPages()
    }

    func updateCurrentPage(_ page: MoodPageDisplayable) {
        currentPage = page
        notifyObservers(.didUpdatePage)
    }

    func didSelectToday() {
        notifyObservers(.didSelectToday)
    }

    func addObserver(_ observer: MoodPagingObserving) {
        let identifier = ObjectIdentifier(observer)
        observations[identifier] = Observation(observer: observer)
        observer.moodPageViewModel(self, didUpdateMoodPage: currentPage)
    }

    private func notifyObservers(_ event: ObserverEvent) {
        observations.forEach { id, observation in
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                return
            }
            switch event {
            case .didUpdatePage:
                observer.moodPageViewModel(self, didUpdateMoodPage: currentPage)
            case .didSelectToday:
                observer.moodPageViewDidSelectToday(self)
            }
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

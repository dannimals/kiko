
import AVFoundation
import KikoUIKit

protocol AnimatedWavesFeedbackGeneratorDelegate: class {

    func feedbackGeneratorDidNotify(_ feedbackGenerator: AnimatedWavesFeedbackGenerator)
}

class AnimatedWavesFeedbackGenerator {

    private var halfMinTimer: Timer?
    private var fullMinTimer: Timer?

    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private let fullMinDuration: TimeInterval = 60
    private let halfMinDuration: TimeInterval = 30
    private let systemSoundID: SystemSoundID = 1008

    weak var delegate: AnimatedWavesFeedbackGeneratorDelegate?

    func fireHalfMinTimer() {
        cancelFullMinTimer()
        halfMinTimer = Timer.scheduledTimer(timeInterval: halfMinDuration, target: self, selector: #selector(notifyTime), userInfo: nil, repeats: false)
    }

    func cancelHalfMinTimer() {
        halfMinTimer?.invalidate()
        halfMinTimer = nil
    }

    func fireFullMinTimer() {
        cancelHalfMinTimer()
        fullMinTimer = Timer.scheduledTimer(timeInterval: fullMinDuration, target: self, selector: #selector(notifyTime), userInfo: nil, repeats: false)
    }

    func reset() {
        cancelHalfMinTimer()
        cancelFullMinTimer()
    }

    func cancelFullMinTimer() {
        fullMinTimer?.invalidate()
        fullMinTimer = nil
    }

    @objc private func notifyTime() {
        AudioServicesPlaySystemSound(systemSoundID)
        feedbackGenerator.notificationOccurred(.success)
        delegate?.feedbackGeneratorDidNotify(self)
    }
}


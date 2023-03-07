import Foundation
import AppFeature

protocol TimeElapsedMonitorDelegate: AnyObject {
    func timeElapsedDidUpdate(_ timeElapsedMonitor: TimeElapsedMonitor, with secondsLeftUntilEvent: TimeInterval)
    func timeElapsedDidStop(_ timeElapsedMonitor: TimeElapsedMonitor)
}

final class TimeElapsedMonitor {
    private let timerScheduler: TimerScheduler
    private var timer: Timer?

    weak var delegate: TimeElapsedMonitorDelegate?

    init(timerScheduler: TimerScheduler = RunLoop.current) {
        self.timerScheduler = timerScheduler
    }

    func start(with eventTime: TimeInterval) {
        // We have to make sure the timer is initialized only once.
        guard timer == nil else {
            return
        }

        // Create a repeating timer instance.
        timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }

            let now = Date().timeIntervalSince1970
//            let secondsLeftUntilEvent = 1678201868 - now
            let secondsLeftUntilEvent = eventTime - now

            if secondsLeftUntilEvent < 0 {
                self.delegate?.timeElapsedDidStop(self)
                self.stop()
            }

            self.delegate?.timeElapsedDidUpdate(self, with: secondsLeftUntilEvent)
        }

        // Fire the initial timer.
        timer?.fire()

        // If the timer has been properly created, we can add it to our scheduler.
        guard let timer = timer else {
            return
        }

        timerScheduler.add(timer, forMode: .default)
    }

    func stop() {
        // If the timer is valid, then we can stop it.
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

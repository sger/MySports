import Foundation

public protocol TimerScheduler {
    func add(_ timer: Timer, forMode mode: RunLoop.Mode)
}

extension RunLoop: TimerScheduler {}

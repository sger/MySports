import Foundation

extension EventCollectionViewCell {
    final class ViewModel {

        private typealias Time = (days: Int, hours: Int, minutes: Int, seconds: Int)

        func timeElapsed(with secondsLeftUntilEvent: TimeInterval) -> String {
            formattedTimeString(with: calculateCountdownTime(from: secondsLeftUntilEvent))
        }

        private func formattedTimeString(with time: Time) -> String {
            "\(time.days.stringWithLeadingZeros):\(time.hours.stringWithLeadingZeros):\(time.minutes.stringWithLeadingZeros):\(time.seconds.stringWithLeadingZeros)"
        }

        private func calculateCountdownTime(from secondsUntilEvent: Double) -> Time {
            let days = Int(secondsUntilEvent / 86400)
            let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))

            return (days, hours, minutes, seconds)
        }
    }
}

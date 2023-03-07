import Foundation

extension EventCollectionViewCell {
    final class ViewModel {

        private typealias Time = (days: Int, hours: Int, minutes: Int, seconds: Int)

        /// Calculate time elapsed between now and a given unix time time
        /// - Parameter secondsLeftUntilEvent: How seconds unti even left
        /// - Returns: A string in format of days/hours/minutes/seconds
        func timeElapsed(with secondsLeftUntilEvent: TimeInterval) -> String {
            formattedTimeString(with: calculateCountdownTime(from: secondsLeftUntilEvent))
        }
        
        /// Formats a Time object in format 00:00:00:00
        /// - Parameter time: The time to format
        /// - Returns: a formatted string
        private func formattedTimeString(with time: Time) -> String {
            "\(time.days.stringWithLeadingZeros):\(time.hours.stringWithLeadingZeros):\(time.minutes.stringWithLeadingZeros):\(time.seconds.stringWithLeadingZeros)"
        }
        
        /// Calculates countdown timer
        /// - Parameter secondsUntilEvent:How seconds unti even left
        /// - Returns: a tuple with days/hours/minutes/seconds
        private func calculateCountdownTime(from secondsUntilEvent: Double) -> Time {
            let days = Int(secondsUntilEvent / 86400)
            let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))

            return (days, hours, minutes, seconds)
        }
    }
}

import Foundation

extension Int {
    var stringWithLeadingZeros: String {
        return String(format: "%02d", self)
    }
}

import Foundation
import UIKit

extension EventCollectionViewCell {
    final class Event {
        var name: String
        var time: TimeInterval
        var isFavorite: Bool

        init(name: String, time: TimeInterval, isFavorite: Bool) {
            self.name = name
            self.time = time
            self.isFavorite = isFavorite
        }
    }
}

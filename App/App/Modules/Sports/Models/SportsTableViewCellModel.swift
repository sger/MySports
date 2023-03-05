import Foundation
import UIKit

final class SportsTableViewCellModel {
    let category: String
    var events: [[EventCollectionViewCell.Event]]
    var updated: [EventCollectionViewCell.Event] = []
    var isExpanded: Bool
    
    init(category: String, events: [[EventCollectionViewCell.Event]], isExpanded: Bool) {
        self.category = category
        self.events = events
        self.isExpanded = isExpanded
    }
    
    func updateEvents(events: [EventCollectionViewCell.Event]) {
        self.updated = events
    }
}

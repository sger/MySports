import Foundation
import UIKit

final class SportsTableViewCellModel {
    let category: String
    let events: [[EventCollectionViewCell.Event]]
    var isExpanded: Bool
    
    init(category: String, events: [[EventCollectionViewCell.Event]], isExpanded: Bool) {
        self.category = category
        self.events = events
        self.isExpanded = isExpanded
    }
}

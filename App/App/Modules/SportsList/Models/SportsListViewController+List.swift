import Foundation
import UIKit

extension SportsListViewController {
    final class List {
        let categoryName: String
        var events: [[EventCollectionViewCell.Event]]
        var isExpanded: Bool
        
        init(categoryName: String, events: [[EventCollectionViewCell.Event]], isExpanded: Bool) {
            self.categoryName = categoryName
            self.events = events
            self.isExpanded = isExpanded
        }
    }
}

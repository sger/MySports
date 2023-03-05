import Foundation
import UIKit

extension SportsListViewController {
    final class List {
        let categoryName: String
        let categoryImage: String
        var events: [[EventCollectionViewCell.Event]]
        var isExpanded: Bool
        
        init(categoryName: String, events: [[EventCollectionViewCell.Event]], isExpanded: Bool, categoryImage: String) {
            self.categoryName = categoryName
            self.events = events
            self.isExpanded = isExpanded
            self.categoryImage = categoryImage
        }
    }
}

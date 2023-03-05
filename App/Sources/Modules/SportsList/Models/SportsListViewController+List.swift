import Foundation
import UIKit

extension SportsListViewController {
    final class List: Equatable {
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
        
        static func == (lhs: SportsListViewController.List, rhs: SportsListViewController.List) -> Bool {
            lhs.categoryName == rhs.categoryName && lhs.categoryImage == rhs.categoryImage
        }
    }
}

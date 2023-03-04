import Foundation
import UIKit

struct SportsTableViewCellModel {
    var category: String
    var events: [[EventCollectionViewCell.Event]]
    var isExpanded: Bool
}

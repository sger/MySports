import UIKit
import AppFeature

final class SportsCollectionViewCell: UICollectionViewCell, NibBackedViewProtocol {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

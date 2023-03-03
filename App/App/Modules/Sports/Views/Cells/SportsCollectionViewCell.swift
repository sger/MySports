import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

import UIKit
import AppFeature

protocol SportsHeaderViewDelegate: AnyObject {
    func sportsHeaderViewDidTapActionButton(_ view: SportsHeaderView, section: Int)
}

final class SportsHeaderView: UIView, NibBackedViewProtocol {

    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!

    weak var delegate: SportsHeaderViewDelegate?
    private var section: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.sportsHeaderTextColor
        categoryLabel.textColor = UIColor.sportsTextColor
        arrowImageView.tintColor = UIColor.sportsTextColor
        setupGestureRecognizer()
        animateArrowImage()
    }

    func configure(with list: SportsListViewController.List, section: Int) {
        categoryLabel.text = list.categoryName
        categoryImageView.image = UIImage(named: list.categoryImage)
        self.section = section
    }

    private func setupGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
    }

    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        animateArrowImage()
        delegate?.sportsHeaderViewDidTapActionButton(self, section: section)
    }

    private func animateArrowImage() {
        UIView.animate(withDuration: 0.5) {
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: 180 * CGFloat(Double.pi/180))
        }
    }
}

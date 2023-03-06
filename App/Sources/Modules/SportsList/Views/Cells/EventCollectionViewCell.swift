import UIKit
import AppFeature

final class EventCollectionViewCell: UICollectionViewCell, NibBackedViewProtocol {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var fillFavoriteImageView: UIImageView!
    
    private let viewModel = EventCollectionViewCell.ViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        backgroundColor = UIColor.sportsBackgroundColor
        infoLabel.isHidden = true
        infoLabel.textColor = UIColor.sportsTextColor
        timeLabel.textColor = UIColor.sportsTextColor
        titleLabel.textColor = UIColor.sportsTextColor

        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 6
        timeLabel.layer.borderColor = UIColor.sportsTextColor.cgColor
        timeLabel.layer.borderWidth = 1.0

        favoriteImageView.tintColor = UIColor.sportsTextColor
        fillFavoriteImageView.isHidden = true
    }

    func configure(with event: Event?) {
        guard let event = event else {
            return
        }

        titleLabel.text = event.name
        
        configureFavoriteEvent(with: event)
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in

            let now = Date().timeIntervalSince1970
            let secondsLeftUntilEvent = 1678116087 - now // event.time

            if secondsLeftUntilEvent < 0 {
                self?.updateUI(with: "Event ended")
                timer.invalidate()
            }

            self?.timeLabel.text = self?.viewModel.timeElapsed(with: secondsLeftUntilEvent)
        }
    }

    private func updateUI(with value: String) {
        infoLabel.text = value
        infoLabel.isHidden = false
        timeLabel.isHidden = true
    }
    
    private func configureFavoriteEvent(with event: Event) {
        guard event.isFavorite else {
            fillFavoriteImageView.isHidden = true
            favoriteImageView.isHidden = false
            return
        }
        
        fillFavoriteImageView.isHidden = false
        favoriteImageView.isHidden = true
    }
}

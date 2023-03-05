import UIKit
import AppFeature

public typealias Time = (days: Int, hours: Int, minutes: Int, seconds: Int)

final class EventCollectionViewCell: UICollectionViewCell, NibBackedViewProtocol {
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    @IBOutlet private weak var fillFavoriteImageView: UIImageView!
    
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
        
        if event.isFavorite {
            fillFavoriteImageView.isHidden = false
            favoriteImageView.isHidden = true
        } else {
            fillFavoriteImageView.isHidden = true
            favoriteImageView.isHidden = false
        }
            
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            let currentUnixTime = Date().timeIntervalSince1970
            let secondsLeftUntilEvent = 1678116087 - currentUnixTime //event.time
            
            if secondsLeftUntilEvent < 0 {
                self.updateUI(with: "Event ended")
                timer.invalidate()
            }
            
            self.updateUI(with: self.countdownTime(from: secondsLeftUntilEvent))

        }
    }
    
    func updateUI(with value: String) {
        infoLabel.isHidden = false
        infoLabel.text = value
        timeLabel.isHidden = true
    }
    
    func updateUI(with time: Time) {
        timeLabel.text = "\(time.days.stringWithLeadingZeros):\(time.hours.stringWithLeadingZeros):\(time.minutes.stringWithLeadingZeros):\(time.seconds.stringWithLeadingZeros)"
    }
    
    func countdownTime(from secondsUntilEvent: Double) -> Time {
        let days = Int(secondsUntilEvent / 86400)
        let hours = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(secondsUntilEvent.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
}

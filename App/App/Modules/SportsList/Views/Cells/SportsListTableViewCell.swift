import UIKit
import AppFeature

protocol SportsListTableViewCellDelegate: AnyObject {
    func sportsListTableViewCellDidUpdateEventsOrder(cell: EventCollectionViewCell?, section: Int, events: [[EventCollectionViewCell.Event]])
}

final class SportsListTableViewCell: UITableViewCell, NibBackedViewProtocol {
    
    weak var delegate: SportsListTableViewCellDelegate?
    private var events: [EventCollectionViewCell.Event] = []
    private var section: Int = 0
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.sportsBackgroundColor
        selectionStyle = .none
        
        setupCollectionViewFlowLayout()
    }
    
    private func setupCollectionViewFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 140, height: 120)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self

        EventCollectionViewCell.register(for: collectionView)
    }
}

extension SportsListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configure(with events: [EventCollectionViewCell.Event], section: Int) {
        self.events = events
        self.section = section
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell
        
        events[indexPath.item].isFavorite = true
    
        let event = events[indexPath.item]
        events.remove(at: indexPath.item)
        events.insert(event, at: 0)
        collectionView.reloadData()
        
        delegate?.sportsListTableViewCellDidUpdateEventsOrder(cell: cell, section: section, events: [events])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EventCollectionViewCell.dequeue(from: collectionView, at: indexPath)
        let event = events[indexPath.item]
        cell.configure(with: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


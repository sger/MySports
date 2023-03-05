import UIKit
import AppFeature

protocol SportsTableViewCellDelegate: AnyObject {
    func collectionView(cell: EventCollectionViewCell?, index: Int, didTappedInTableViewCell: SportsTableViewCell)
}

final class SportsTableViewCell: UITableViewCell, NibBackedViewProtocol {
    
    weak var delegate: SportsTableViewCellDelegate?
    private var events: [EventCollectionViewCell.Event] = []
    
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

extension SportsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configure(with events: [EventCollectionViewCell.Event]) {
        self.events = events
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell
        delegate?.collectionView(cell: cell, index: indexPath.item, didTappedInTableViewCell: self)

        events[indexPath.item].isFavorite = true
        print("favorite: \(events[indexPath.item])")
        
        events = events.sorted(by:{ $0.isFavorite && !$1.isFavorite})

        print(events)
        collectionView.reloadData()
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
        UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}


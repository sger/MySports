import UIKit
import AppFeature

protocol SportsTableViewCellDelegate: AnyObject {
    func collectionView(cell: EventCollectionViewCell?, index: Int, didTappedInTableViewCell: SportsTableViewCell)
    func update(cell: EventCollectionViewCell?, sportsData: [SportsTableViewCellModel])
    func updateOrderEvents(cell: EventCollectionViewCell?, section: Int, events: [[EventCollectionViewCell.Event]])
}

final class SportsTableViewCell: UITableViewCell, NibBackedViewProtocol {
    
    weak var delegate: SportsTableViewCellDelegate?
    private var events: [EventCollectionViewCell.Event] = []
    private var sportsData: [SportsTableViewCellModel] = []
    public var section: Int = 0
    
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
    
    func configure(with events: [EventCollectionViewCell.Event], sportsData: [SportsTableViewCellModel], section: Int) {
        self.events = events
        self.sportsData = sportsData
        self.section = section
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell
        delegate?.collectionView(cell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        
        events[indexPath.item].isFavorite = true
        print("favorite: \(events[indexPath.item].name)")
    
        let row = events[indexPath.item]
        events.remove(at: indexPath.item)
        events.insert(row, at: 0)
        collectionView.reloadData()
        
        print("section \(section)")
        
//        sportsData[section].events = [events]
//        
//        for event in sportsData[section].events {
//            for row in event {
//                print("\(row.name) -> \(row.isFavorite)")
//            }
//        }
//        
//        print(sportsData[section].events.indices)
//        
//        print("----------")
        
//        delegate?.update(cell: cell, sportsData: sportsData)
        
        delegate?.updateOrderEvents(cell: cell, section: section, events: [events])
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


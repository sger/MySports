import UIKit
import AppFeature
import Networking

final class SportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    private var sportsData: [SportsTableViewCellModel] = []
    private var viewModel: SportsViewController.ViewModel = SportsViewController.ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sports"
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .systemRed
        view.backgroundColor = UIColor.sportsBackgroundColor
        
        setupTableView()
        loadSportsData()
    }
    
    private func loadSportsData() {
        viewModel.fetchSports { result in
            switch result {
            case let .success(sportsData):
                self.sportsData = sportsData
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.sportsBackgroundColor
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        SportsTableViewCell.register(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SportsHeaderView.loadFromNib()
        view.configure(with: sportsData[section].category, section: section)
        view.delegate = self
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sportsData[section].isExpanded else {
            return 0
        }
            
        return sportsData[section].events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sportsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SportsTableViewCell.dequeue(from: tableView, at: indexPath)
        let events = sportsData[indexPath.section].events[indexPath.row]
        cell.configure(with: events, sportsData: sportsData, section: indexPath.section)
        cell.delegate = self
        return cell
    }
    
    @objc func handleExpandClose(section: Int) {
        var indexPaths = [IndexPath]()
        
        print("handleExpandClose")
        
        for event in sportsData[section].events {
            for row in event {
                print("\(row.name) -> \(row.isFavorite)")
            }
        }
        
        print(sportsData[section].events.indices)
        
        for row in sportsData[section].events.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = sportsData[section].isExpanded
        sportsData[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

extension SportsViewController: StoryboardCreatable {
    static var storyboard: StoryboardRepresentable {
        Storyboard.main
    }
}

extension SportsViewController: SportsHeaderViewDelegate {
    func sportsHeaderViewDidTapActionButton(_ view: SportsHeaderView, section: Int) {
        handleExpandClose(section: section)
    }
}

extension SportsViewController: SportsTableViewCellDelegate {
    func updateOrderEvents(cell: EventCollectionViewCell?, section: Int, events: [[EventCollectionViewCell.Event]]) {
        sportsData[section].events = events
        
        for event in sportsData[section].events {
            for row in event {
                print("\(row.name) -> \(row.isFavorite)")
            }
        }
        
        print(sportsData[section].events.indices)
        
        print("----------")
    }
    
    func collectionView(cell: EventCollectionViewCell?, index: Int, didTappedInTableViewCell: SportsTableViewCell) {
        
    }
    
    func update(cell: EventCollectionViewCell?, sportsData: [SportsTableViewCellModel]) {
        self.sportsData = sportsData
    }
    
    
}

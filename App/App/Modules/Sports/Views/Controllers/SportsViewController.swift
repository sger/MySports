import UIKit
import AppFeature
import Networking

final class SportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    private var items: [TableViewCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sports"
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.lightGray
        
        let api = APIClient()
        api.fetchSports { result in
            switch result {
                case .success(let result):
            
                result.forEach {
                    let events = $0.events.map {
                        CollectionViewCellModel(color: .red, name: $0.name)
                    }
                    let cell = TableViewCellModel(category: $0.name, items: [events], isExpanded: true)
                    self.items.append(cell)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
        
        SportsTableViewCell.register(for: tableView)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.setTitle(items[section].category, for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard items[section].isExpanded else {
            return 0
        }
            
        return items[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SportsTableViewCell.dequeue(from: tableView, at: indexPath)
        let rowArray = items[indexPath.section].items[indexPath.row]
        cell.updateCellWith(row: rowArray)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func handleExpandClose(button: UIButton) {
        var indexPaths = [IndexPath]()
        let section = button.tag
        
        for row in items[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = items[section].isExpanded
        items[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
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

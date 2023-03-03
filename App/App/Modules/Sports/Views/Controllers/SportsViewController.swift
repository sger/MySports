import UIKit
import AppFeature
import Networking

final class SportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    private var data: [SportsTableViewCellModel] = []
    
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
                        SportsCollectionViewCellModel(name: $0.name)
                    }
                    let cell = SportsTableViewCellModel(category: $0.name, events: [events], isExpanded: true)
                    self.data.append(cell)
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
        button.setTitle(data[section].category, for: .normal)
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
        guard data[section].isExpanded else {
            return 0
        }
            
        return data[section].events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SportsTableViewCell.dequeue(from: tableView, at: indexPath)
        let data = data[indexPath.section].events[indexPath.row]
        cell.configure(with: data)
        return cell
    }
    
    @objc func handleExpandClose(button: UIButton) {
        var indexPaths = [IndexPath]()
        let section = button.tag
        
        for row in data[section].events.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = data[section].isExpanded
        data[section].isExpanded = !isExpanded
        
//        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
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

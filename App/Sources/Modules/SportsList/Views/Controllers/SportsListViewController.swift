import UIKit
import AppFeature
import Networking

final class SportsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum State<T> {
        case loading
        case loaded(T)
        case error(Error)
    }

    @IBOutlet private weak var tableView: UITableView!

    private var list: [SportsListViewController.List] = []
    private var viewModel: SportsListViewController.ViewModel = SportsListViewController.ViewModel()
    
    private var state: State<[SportsListViewController.List]> = .loading {
        didSet {
            switch state {
            case .loading:
                break
            case let .loaded(response):
                DispatchQueue.main.async {
                    self.list = response
                    self.tableView.reloadData()
                }
            case let .error(error):
                print(error)
                // Handle error from server
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerAttributes()
        setupTableView()
        loadSportsData()
    }

    private func setupViewControllerAttributes() {
        title = "My Sports"
        view.backgroundColor = UIColor.sportsBackgroundColor
    }

    private func loadSportsData() {
        state = .loading
        
        viewModel.fetchSports { result in
            switch result {
            case let .success(sportsData):
                self.state = .loaded(sportsData)
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor.sportsBackgroundColor
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        SportsListTableViewCell.register(for: tableView)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SportsHeaderView.loadFromNib()
        view.configure(with: list[section], section: section)
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
        guard list[section].isExpanded else {
            return 0
        }

        return list[section].events.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SportsListTableViewCell.dequeue(from: tableView, at: indexPath)
        let events = list[indexPath.section].events[indexPath.row]
        cell.configure(with: events, section: indexPath.section)
        cell.delegate = self
        return cell
    }

    private func headerViewTapped(with section: Int) {
        var indexPaths = [IndexPath]()
        
        list[section].events.indices.forEach {
            indexPaths.append(IndexPath(item: $0, section: section))
        }

        let isExpanded = list[section].isExpanded
        list[section].isExpanded = !isExpanded

        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

extension SportsListViewController: StoryboardCreatable {
    static var storyboard: StoryboardRepresentable {
        Storyboard.main
    }
}

extension SportsListViewController: SportsHeaderViewDelegate {
    func sportsHeaderViewDidTapActionButton(_ view: SportsHeaderView, section: Int) {
        headerViewTapped(with: section)
    }
}

extension SportsListViewController: SportsListTableViewCellDelegate {
    func sportsListTableViewCellDidUpdateEventsOrder(cell: EventCollectionViewCell?, section: Int, events: [[EventCollectionViewCell.Event]]) {
        list[section].events = events
    }
}

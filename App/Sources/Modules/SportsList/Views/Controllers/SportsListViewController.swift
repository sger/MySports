import UIKit
import AppFeature
import Networking
import Combine
import CombineSchedulers

final class SportsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!

    private var list: [SportsListViewController.List] = []
    private var viewModel: SportsListViewModelProtocol?
    private var disposeBag = Set<AnyCancellable>()
    private var scheduler: AnySchedulerOf<DispatchQueue>?

    static func instatiate(with viewModel: SportsListViewModelProtocol, scheduler: AnySchedulerOf<DispatchQueue> = .main) -> SportsListViewController {
        let viewController = SportsListViewController.create()
        viewController.viewModel = viewModel
        viewController.scheduler = scheduler
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllerAttributes()
        setupTableView()

        guard let scheduler = scheduler else {
            return
        }

        viewModel?.viewDidLoad()
        viewModel?
            .currentValueSubject
            .receive(on: scheduler)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] state in
                switch state {
                case .loading:
                    break
                case .loaded(let result):
                    self?.list = result

                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .empty:
                    break
                case .error:
                    break
           }
       })
       .store(in: &disposeBag)
    }

    private func setupViewControllerAttributes() {
        title = "My Sports"
        view.backgroundColor = UIColor.sportsBackgroundColor
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

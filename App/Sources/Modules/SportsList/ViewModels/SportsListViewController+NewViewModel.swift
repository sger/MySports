import Foundation
import Combine
import CombineSchedulers

enum State<Entity: Equatable> {
  case loading
  case loaded([Entity])
  case empty
  case error(String)
}

extension State: Equatable {

  static public func == (lhs: State<Entity>, rhs: State<Entity>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (let .loaded(lhs), let .loaded(rhs)):
      return lhs == rhs
    case (.empty, .empty):
      return true
    case (.error, .error):
      return true

    default:
      return false
    }
  }
}

protocol NewViewModelProtcol {
    func viewDidLoad()
    var currentValueSubject: CurrentValueSubject<State<SportsListViewController.List>, Never> { get }
}

extension SportsListViewController {
    final class NewViewModel: NewViewModelProtcol {
        private let useCase: SportsListUseCaseProtocol
        private let scheduler: AnySchedulerOf<DispatchQueue>
        private var disposeBag = Set<AnyCancellable>()

        let currentValueSubject = CurrentValueSubject<State<SportsListViewController.List>, Never>(.loading)

        init(useCase: SportsListUseCaseProtocol, scheduler: AnySchedulerOf<DispatchQueue> = .main) {
            self.useCase = useCase
            self.scheduler = scheduler
        }
        
        func viewDidLoad() {
            fetchSportsList()
        }

        private func fetchSportsList() {
            useCase.execute()
                .receive(on: scheduler)
                .sink { [weak self] subscriber in
                    switch subscriber {
                    case .finished:
                        break
                    case let .failure(error):
                        self?.currentValueSubject.send(.error(error.localizedDescription))
                    }
                } receiveValue: { [weak self] result in
                    self?.currentValueSubject.send(.loaded(result))
                }.store(in: &disposeBag)
        }
    }
}

import Foundation
import Combine
import CombineSchedulers

extension SportsListViewController {
    final class NewViewModel {
        private let useCase: SportsListUseCase
        private let scheduler: AnySchedulerOf<DispatchQueue>
        private var disposeBag = Set<AnyCancellable>()
        
        let currentValueSubject = CurrentValueSubject<State<SportsListViewController.List>, Never>(.loading)
        
        init(useCase: SportsListUseCase, scheduler: AnySchedulerOf<DispatchQueue> = .main) {
            self.useCase = useCase
            self.scheduler = scheduler
        }
        
        func fetchSportsList() {
            useCase.execute()
                .receive(on: scheduler)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                        case let .failure(error):
                            print(error)
                        case .finished: break
                    }
                }, receiveValue: { [weak self] result in
                    self?.currentValueSubject.send(.loaded(result))
                })
                .store(in: &disposeBag)
        }
    }
}

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
    case (let .loaded(lhShows), let .loaded(rhShows)):
      return lhShows == rhShows

    case (.empty, .empty):
      return true
    case (.error, .error):
      return true

    default:
      return false
    }
  }
}

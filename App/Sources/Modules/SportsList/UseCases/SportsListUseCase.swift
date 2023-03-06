import Foundation
import Combine
import Networking

protocol SportsListUseCaseProtocol {
    func execute() -> AnyPublisher<[SportsListViewController.List], DataTransferError>
}

final class SportsListUseCase {
    private let repository: SportsListRepository
    
    init(repository: SportsListRepository) {
        self.repository = repository
    }
}

extension SportsListUseCase: SportsListUseCaseProtocol {
    func execute() -> AnyPublisher<[SportsListViewController.List], Networking.DataTransferError> {
        repository.fetchSportsList()
    }
}

import Foundation
import Combine
import Networking
import Models

protocol SportsListRepositoryProtocol {
    func fetchSportsList() -> AnyPublisher<[SportsListViewController.List], DataTransferError>
}

final class SportsListRepository {
    private let dataTransferService: DataTransferService
    private let sportsListMapper: SportsListMapper
    
    init(dataTransferService: DataTransferService, sportsListMapper: SportsListMapper) {
        self.dataTransferService = dataTransferService
        self.sportsListMapper = sportsListMapper
    }
}

extension SportsListRepository: SportsListRepositoryProtocol {
    func fetchSports() -> AnyPublisher<[Models.SportsDTO], DataTransferError> {
        let endpoint = Endpoint<[Models.SportsDTO]>(path: "sports", method: .get)
        return dataTransferService.request(with: endpoint).eraseToAnyPublisher()
    }
    
    func fetchSportsList() -> AnyPublisher<[SportsListViewController.List], Networking.DataTransferError> {
        fetchSports()
            .map { self.sportsListMapper.mapSportsListDTO($0) }
            .eraseToAnyPublisher()
    }
}

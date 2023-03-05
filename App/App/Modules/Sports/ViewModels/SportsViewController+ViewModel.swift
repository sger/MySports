import Foundation
import Networking

extension SportsListViewController {
    final class ViewModel {
        private let apiClient: SportsType
        private var sportsData: [SportsTableViewCellModel] = []
        
        init(apiClient: SportsType = APIClient()) {
            self.apiClient = apiClient
        }
        
        func fetchSports(completion: @escaping (Result<[SportsTableViewCellModel], Error>) -> Void) {
            apiClient.fetchSports { result in
                switch result {
                case let .success(response):
                    response.forEach {
                        let events = $0.events.map {
                            EventCollectionViewCell.Event(name: $0.name, time: $0.time, isFavorite: false)
                        }
                        let cell = SportsTableViewCellModel(category: $0.name, events: [events], isExpanded: true)
                        self.sportsData.append(cell)
                    }
                    
                    completion(.success(self.sportsData))
                    
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}

import Foundation
import Networking

extension SportsListViewController {
    final class ViewModel {
        private let apiClient: SportsType

        init(apiClient: SportsType = APIClient()) {
            self.apiClient = apiClient
        }

        func fetchSports(completion: @escaping (Result<[SportsListViewController.List], Error>) -> Void) {
            apiClient.fetchSports { result in
                switch result {
                case let .success(response):
                    completion(.success(SportsListMapper().mapSportsListDTO(response)))
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
}

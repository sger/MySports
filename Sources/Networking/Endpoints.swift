import Foundation
import Models

public protocol SportsType {
    func fetchSports(completionHandler: (@escaping (Result<[SportsDTO], Error>) -> Void))
}

extension APIClient: SportsType {
    public func fetchSports(completionHandler: (@escaping (Result<[SportsDTO], Error>) -> Void)) {
        request("sports", completionHandler: completionHandler)
    }
}

import Foundation
import Combine

public class DefaultNetworkSessionManager: NetworkSessionManager {

  public init() {}

  public func request(_ request: URLRequest) -> AnyPublisher<NetworkingOutput, URLError> {
    return URLSession.shared.dataTaskPublisher(for: request).eraseToAnyPublisher()
  }
}

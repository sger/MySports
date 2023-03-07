import Foundation
import Networking

final class AppDependencies {
    // swiftlint:disable force_unwrapping
    lazy var dataTranferService: DataTransferService = {
      let configuration = ApiDataNetworkConfig(baseURL: URL(string: "https://618d3aa7fe09aa001744060a.mockapi.io/api/")!)

      let networkService = DefaultNetworkService(config: configuration)
      return DefaultDataTransferService(with: networkService)
    }()
}

import Foundation
import Networking

class AppDependencies {
    lazy var apiDataTransferService: DataTransferService = {
      let configuration = ApiDataNetworkConfig(baseURL: URL(string: "https://618d3aa7fe09aa001744060a.mockapi.io/api/")!)
        
      let networkService = DefaultNetworkService(config: configuration)
      return DefaultDataTransferService(with: networkService)
    }()
}

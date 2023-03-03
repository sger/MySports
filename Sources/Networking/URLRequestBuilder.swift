import Foundation
import os.log

struct URLRequestBuilder {
    func buildURL(_ endpoint: String, method: APIClient.HTTPMethod, parameters: Parameters) -> URLRequest? {
        guard let url = URL(string: APIClient.Config.baseURL + endpoint) else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        switch method {
        case .get:
            urlRequest.url?.appendQueryParameters(parameters)
        }
        os_log("%@ %s",
               log: Log.APIClient,
               type: .debug, #function,
               urlRequest.url?.absoluteString ?? "")
        return urlRequest
    }
}

// swiftlint:disable force_unwrapping
extension URL {
    @discardableResult
    func appendingQueryParameters(_ paramaters: Parameters) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += paramaters.map { URLQueryItem(name: $0, value: "\($1)") }
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    mutating func appendQueryParameters(_ parameters: Parameters) {
        self = appendingQueryParameters(parameters)
    }
}

struct Log {
    static var APIClient = OSLog(subsystem: "DailyNews",
                                 category: "APIClient")
}

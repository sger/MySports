import Foundation
import os.log
import Models

typealias Parameters = [String: Any]

public final class APIClient {

    enum ClientError: Error {
        case decoding(message: String)
        case unauthorized
        case forbidden
        case notFound
        case other(String)
    }

    enum Config {
        static let baseURL = "https://618d3aa7fe09aa001744060a.mockapi.io/api/"
    }

    enum HTTPMethod: String {
        case get = "GET"
    }

    private let urlSession = URLSession(configuration: .default)
    
    public init() {}

    @discardableResult
    func request<T: Decodable>(_ endpoint: String,
                               method: HTTPMethod = .get,
                               parameters: Parameters = [:],
                               completionHandler: (@escaping (Result<T, Error>) -> Void)) -> APIRequest? {
        guard let urlRequest = URLRequestBuilder().buildURL(endpoint, method: method, parameters: parameters) else {
            return nil
        }

        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return
                }

                switch response.statusCode {
                case 401:
                    completionHandler(.failure(ClientError.unauthorized))
                case 403:
                    completionHandler(.failure(ClientError.forbidden))
                case 404:
                    completionHandler(.failure(ClientError.notFound))
                case let code where code / 100 != 2:
                    completionHandler(.failure(ClientError.other("Error status code: \(response.statusCode)")))
                default:
                    guard let data = data, let object = APIClient.createModel(model: T.self, fromData: data) else {
                        completionHandler(.failure(ClientError.other("Error nil response")))
                        return
                    }
                    completionHandler(.success(object))
                }
            }
        }
        task.resume()
        return APIRequest(task: task)
    }

    public static func createModel<T: Decodable>(model: T.Type,
                                          fromData data: Data?,
                                          withCamelCaseConvertion convert: Bool = true,
                                          dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) -> T? {
        guard let data = data else {
            return nil
        }

        let decoder = JSONDecoder()
        do {
            if convert {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = dateDecodingStrategy
            }
            let model = try decoder.decode(model, from: data)
            return model

        } catch let error {
            print(error)
            return nil
        }
     }
}

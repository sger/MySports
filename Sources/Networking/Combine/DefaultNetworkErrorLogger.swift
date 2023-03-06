import Foundation
import os.log

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {

  public init() { }

  public func log(request: URLRequest) {
    os_log("%@ %s",
           log: Log.APIClient,
           type: .debug, #function,
           "request: \(request.url!), headers: \(request.allHTTPHeaderFields!), method: \(request.httpMethod!)")

    if let httpBody = request.httpBody,
       let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
        os_log("%@ %s",
               log: Log.APIClient,
               type: .debug, #function,
               "body: \(String(describing: result))")
    } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
        os_log("%@ %s",
               log: Log.APIClient,
               type: .debug, #function,
               "body: \(String(describing: resultString))")
    }
  }

  public func log(responseData data: Data?, response: URLResponse?) {
    guard let data = data else { return }
    if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        os_log("%@ %s",
               log: Log.APIClient,
               type: .debug, #function,
               "responseData: \(String(describing: dataDict))")
    }
  }

  public func log(responseData data: Data, response: URLResponse) {}

    public func log(error: Error) {
      os_log("%@ %s",
             log: Log.APIClient,
             type: .debug, #function,
             error.localizedDescription)
  }
}

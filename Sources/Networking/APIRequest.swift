import Foundation
import UIKit

public final class APIRequest: NSObject {
    private weak var task: URLSessionDataTask?

    public init(task: URLSessionDataTask) {
        self.task = task
    }

    public func cancel() {
        task?.cancel()
    }
}

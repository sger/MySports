import Foundation

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
  public init() { }

  public func resolve(error: NetworkError) -> Error {
    return error
  }
}

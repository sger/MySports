import os.log

public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
  public init() { }

  public func log(error: Error) {
      os_log("%@ %s",
             log: Log.APIClient,
             type: .debug, #function,
             error.localizedDescription)
  }
}

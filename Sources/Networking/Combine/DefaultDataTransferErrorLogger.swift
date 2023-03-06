public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
  public init() { }

  public func log(error: Error) {
    printIfDebug("-------------")
    printIfDebug("\(error)")
  }
}

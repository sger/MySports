//
//  File.swift
//  
//
//  Created by Spiros Gerokostas on 6/3/23.
//

import Foundation

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
  public init() { }

  public func resolve(error: NetworkError) -> Error {
    return error
  }
}

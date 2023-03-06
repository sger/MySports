//
//  EventCollectionViewCellViewModelTests.swift
//  MySportsTests
//
//  Created by Spiros Gerokostas on 6/3/23.
//

import XCTest
@testable import MySports

final class EventCollectionViewCellViewModelTests: XCTestCase {

    func testViewModel_whenTimeElapsed() throws {
        let sut = EventCollectionViewCell.ViewModel()

        let now = Date(timeIntervalSince1970: 1678101452)
        let eventTime: TimeInterval = 1678105052
        let secondsLeftUntilEvent = eventTime - now.timeIntervalSince1970

        XCTAssertEqual(sut.timeElapsed(with: secondsLeftUntilEvent), "00:01:00:00")
    }
}

//
//  SportsListViewControllerNewViewModelTests.swift
//  MySportsTests
//
//  Created by Spiros Gerokostas on 6/3/23.
//

import XCTest
@testable import MySports
import Combine
import Networking
import SnapshotTesting

final class SportsListViewControllerNewViewModelTests: XCTestCase {
    private var useCaseMock: SportsListUseCaseMock?
    private var disposeBag: Set<AnyCancellable>?

    override func setUpWithError() throws {
        useCaseMock = SportsListUseCaseMock()
        disposeBag = []
    }

    func testWhenViewModelIsLoadingThenShowList() throws {
        let useCaseMock = try XCTUnwrap(self.useCaseMock)
        var disposeBag = try XCTUnwrap(self.disposeBag)

        let event = EventCollectionViewCell.Event(name: "Juventus FC - Paris Saint-Germain", time: 1667447160, isFavorite: false)
        let list = SportsListViewController.List(categoryName: "SOCCER", events: [[event]], isExpanded: true, categoryImage: "football")

        useCaseMock.result = [list]

        let expected = [
          State<SportsListViewController.List>.loading,
          State<SportsListViewController.List>.loaded([list])
        ]

        var received = [State<SportsListViewController.List>]()

        let sut = SportsListViewController.ViewModel(useCase: useCaseMock, scheduler: .immediate)

        sut.currentValueSubject.removeDuplicates()
          .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

        sut.viewDidLoad()

        XCTAssertEqual(expected, received, "should contain 1 item in list")
    }
}

class SportsListUseCaseMock: SportsListUseCaseProtocol {
    var error: DataTransferError?
    var result: [SportsListViewController.List]?

    func execute() -> AnyPublisher<[SportsListViewController.List], Networking.DataTransferError> {
        if let error = error {
          return Fail(error: error).eraseToAnyPublisher()
        }

        if let result = result {
          return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
        }

        return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }
}

class SportsListViewModelMock: SportsListViewModelProtocol {
    func viewDidLoad() {}

    let currentValueSubject: CurrentValueSubject<State<SportsListViewController.List>, Never>

    init(state: State<SportsListViewController.List>) {
        currentValueSubject = CurrentValueSubject(state)
    }
}

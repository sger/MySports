//
//  SportsViewControllerViewModelTests.swift
//  MySportsTests
//
//  Created by Spiros Gerokostas on 5/3/23.
//

import XCTest
@testable import MySports
import Models
import Networking

final class SportsViewControllerViewModelTests: XCTestCase {

    lazy private var sportsDTO: [SportsDTO]? = {
        guard let data = TestUtilities.dataFromJSON(file: "my_sports", bundle: Bundle(for: type(of: self))),
              let dataDTO = APIClient.createModel(model: [SportsDTO].self, fromData: data) else {
            return []
        }
        return dataDTO
    }()

    func testViewModelResponse() throws {
        let sportsDTO = try XCTUnwrap(self.sportsDTO)
        let response: Result<[SportsDTO], Error> = .success(sportsDTO)
        let mockApiClient = MockApiClient(response: response)

        let event = EventCollectionViewCell.Event(name: "Juventus FC - Paris Saint-Germain", time: 1667447160, isFavorite: false)
        let list = SportsListViewController.List(categoryName: "SOCCER", events: [[event]], isExpanded: true, categoryImage: "football")

        let sut = SportsListViewController.ViewModel(apiClient: mockApiClient)
        sut.fetchSports { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response, [list])
            case .failure:
                break
            }
        }
    }
}

final class MockApiClient: SportsType {
    var response: Result<[Models.SportsDTO], Error>

    init(response: Result<[Models.SportsDTO], Error>) {
        self.response = response
    }

    func fetchSports(completionHandler: @escaping ((Result<[Models.SportsDTO], Error>) -> Void)) {
        completionHandler(self.response)
    }
}

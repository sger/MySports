//
//  SportsListViewControllerTests.swift
//  MySportsTests
//
//  Created by Spiros Gerokostas on 6/3/23.
//

import XCTest
@testable import MySports
import Combine
import Networking
import SnapshotTesting

final class SportsListViewControllerTests: XCTestCase {
    
    private var useCaseMock: SportsListUseCaseMock?

    override func setUpWithError() throws {
        useCaseMock = SportsListUseCaseMock()
//        isRecording = true
    }
    
    func testViewControllerWhenEventIsNotFavorite() throws {
        let useCaseMock = try XCTUnwrap(self.useCaseMock)
        let event = EventCollectionViewCell.Event(name: "Juventus FC - Paris Saint-Germain", time: 0, isFavorite: false)
        let list = SportsListViewController.List(categoryName: "SOCCER", events: [[event]], isExpanded: true, categoryImage: "football")
        useCaseMock.result = [list]
        
        let viewModel = SportsListViewController.NewViewModel(useCase: useCaseMock, scheduler: .immediate)
        
        let viewController = SportsListViewController.instatiate(with: viewModel, scheduler: .immediate)
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testViewControllerWhenEventIsFavorite() throws {
        let useCaseMock = try XCTUnwrap(self.useCaseMock)
        let event = EventCollectionViewCell.Event(name: "Juventus FC - Paris Saint-Germain", time: 0, isFavorite: true)
        let list = SportsListViewController.List(categoryName: "SOCCER", events: [[event]], isExpanded: true, categoryImage: "football")
        useCaseMock.result = [list]
        
        let viewModel = SportsListViewController.NewViewModel(useCase: useCaseMock, scheduler: .immediate)
        
        let viewController = SportsListViewController.instatiate(with: viewModel, scheduler: .immediate)
        assertSnapshot(matching: viewController, as: .image)
    }
    
    func testViewControllerWhenEventIsNotFavoriteAndCollapsed() throws {
        let useCaseMock = try XCTUnwrap(self.useCaseMock)
        let event = EventCollectionViewCell.Event(name: "Juventus FC - Paris Saint-Germain", time: 0, isFavorite: false)
        let listSoccer = SportsListViewController.List(categoryName: "SOCCER", events: [[event]], isExpanded: false, categoryImage: "football")
        let listBasketball = SportsListViewController.List(categoryName: "BASKETBALL", events: [[event]], isExpanded: true, categoryImage: "basketball")
        useCaseMock.result = [listSoccer, listBasketball]
        
        let viewModel = SportsListViewController.NewViewModel(useCase: useCaseMock, scheduler: .immediate)
        
        let viewController = SportsListViewController.instatiate(with: viewModel, scheduler: .immediate)
        assertSnapshot(matching: viewController, as: .image)
    }

}

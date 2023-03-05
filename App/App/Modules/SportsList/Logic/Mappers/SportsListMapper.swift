import Foundation
import Models

protocol SportsListMapperProtocol {
    func mapSportsListDTO(_ model: [Models.SportsDTO]) -> [SportsListViewController.List]
}

final class SportsListMapper: SportsListMapperProtocol {
    func mapSportsListDTO(_ model: [Models.SportsDTO]) -> [SportsListViewController.List] {
        model.map {
            let events = $0.events.map { EventCollectionViewCell.Event(name: $0.name, time: $0.time, isFavorite: false) }
            return SportsListViewController.List(categoryName: $0.name, events: [events], isExpanded: true)
        }
    }
}

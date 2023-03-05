import Foundation
import AppFeature

final class SportsCoordinator: BaseCoordinator {
    private let router: Router
    private var sportsViewController: SportsListViewController?

    init(router: Router) {
        self.router = router
    }

    override func start() {
        let sportsViewController = SportsListViewController.create()
        
        router.push(sportsViewController, animated: false)
        self.sportsViewController = sportsViewController
    }
}

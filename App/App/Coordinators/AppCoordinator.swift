import Foundation
import UIKit
import AppFeature

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    private let rootViewController: UINavigationController
    private let sportsCoordinator: SportsCoordinator

    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()

        let navigationRouter = NavigationRouter(navigationController: rootViewController)
        sportsCoordinator = SportsCoordinator(router: navigationRouter)
    }

    override func start() {
        window.rootViewController = rootViewController
        add(sportsCoordinator)
        sportsCoordinator.start()
        
        window.makeKeyAndVisible()
    }
}

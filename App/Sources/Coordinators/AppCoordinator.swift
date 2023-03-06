import Foundation
import UIKit
import AppFeature

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    private let rootViewController: UINavigationController
    private let sportsCoordinator: SportsListCoordinator
    private let appDependencies: AppDependencies

    init(window: UIWindow, appDependencies: AppDependencies) {
        self.window = window
        self.appDependencies = appDependencies
        self.rootViewController = UINavigationController()

        let navigationRouter = NavigationRouter(navigationController: rootViewController)
        sportsCoordinator = SportsListCoordinator(router: navigationRouter, appDependencies: appDependencies)
    }

    override func start() {
        window.rootViewController = rootViewController
        add(sportsCoordinator)
        sportsCoordinator.start()

        window.makeKeyAndVisible()
    }
}

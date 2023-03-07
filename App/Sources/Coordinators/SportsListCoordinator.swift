import Foundation
import AppFeature

final class SportsListCoordinator: BaseCoordinator {
    private let router: Router
    private var sportsViewController: SportsListViewController?
    private let appDependencies: AppDependencies

    init(router: Router, appDependencies: AppDependencies) {
        self.router = router
        self.appDependencies = appDependencies
    }

    override func start() {
        let repository = SportsListRepository(dataTransferService: appDependencies.dataTranferService, sportsListMapper: SportsListMapper())
        let useCase = SportsListUseCase(repository: repository)
        let viewModel = SportsListViewController.ViewModel(useCase: useCase)

        let sportsViewController = SportsListViewController.instatiate(with: viewModel)

        router.push(sportsViewController, animated: false)
        self.sportsViewController = sportsViewController
    }
}

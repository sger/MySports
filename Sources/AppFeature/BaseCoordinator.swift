import Foundation

open class BaseCoordinator: Coordinator {

    public var children: [Coordinator] = []

    public init() {}

    open func start() {
        fatalError("Start method should be implemented.")
    }

    public func add(_ coordinator: Coordinator) {
        guard !children.contains(where: { $0 === coordinator }) else {
            print("Failed to add coordinator \(coordinator) because it exists")
            return
        }

        children.append(coordinator)
    }

    public func remove(_ coordinator: Coordinator?) {
        guard !children.isEmpty, let coordinator = coordinator else {
            print("Failed to remove coordinator")
            return
        }

        if let coordinator = coordinator as? BaseCoordinator, !coordinator.children.isEmpty {
            coordinator.children
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.remove($0) })
        }

        for (index, element) in children.enumerated() where element === coordinator {
            children.remove(at: index)
            break
        }
    }
}

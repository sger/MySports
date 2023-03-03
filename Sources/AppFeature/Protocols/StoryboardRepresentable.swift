import Foundation
import UIKit

/// Blueprint implementation of a type that represents storyboard names.
///
/// For correct usage, always inherit from this protocol on `String` enumerations.
public protocol StoryboardRepresentable {
    /// The name of the storyboard.
    var rawValue: String { get }

    /// Loads and creates and instance of the specified view controller.
    /// - Parameter type: The class of the view controller.
    /// - Returns: An instance loaded from the storyboard.
    func instantiate<T: StoryboardCreatable>(for type: T.Type) -> T
}

extension StoryboardRepresentable {
    public func instantiate<T: StoryboardCreatable>(for type: T.Type) -> T {
        // Load the storyboard from the bundle where the implementing class resides.
        let rawStoryboard = UIStoryboard(name: rawValue,
                                         bundle: Bundle(for: type))

        // Then try to create an instance of the view controller with the specified identifier.
        guard let viewController = rawStoryboard.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Cannot instantiate the view controller with identifier \(T.identifier) from \(rawValue)!")
        }

        // Return the successfully created instance of the view controller.
        return viewController
    }
}

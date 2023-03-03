import Foundation
import UIKit

/// Standardized way for initializing view controllers from storyboards.
public protocol StoryboardCreatable: AnyObject, StoryboardIdentifiable {
    /// Storyboard where the view controller is located.
    static var storyboard: StoryboardRepresentable { get }

    /// Creates and returns a new view controller instance.
    static func create() -> Self
}

// MARK: - Default UIViewController Implementation
public extension StoryboardCreatable where Self: UIViewController {
    static func create() -> Self {
        storyboard.instantiate(for: Self.self)
    }
}

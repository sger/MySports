import Foundation
import UIKit

// MARK: - Protocol declaration

/// Blueprint implementation of a type that has a storyboard identifier set.
public protocol StoryboardIdentifiable {
    /// A storyboard identifier used by view controller and table/collection cell subclasses.
    ///
    /// By convention, the identifier (set in Interface Builder) and the class name **should be identical**.
    ///
    /// - Important: For nib-backed cells, the filename should also be equal to this identifier.
    static var identifier: String { get }
}

// MARK: - Default Implementation

extension StoryboardIdentifiable {
    public static var identifier: String {
        String(describing: self)
    }
}

// MARK: - Default Conformance

extension UIViewController: StoryboardIdentifiable {}

import Foundation
import UIKit

// MARK: - Protocol declaration

/// Describes any view that uses the reusability mechanism.
public protocol ReusableViewProtocol: UIView, StoryboardIdentifiable {
    /// Returns the reuse identifier, defaults to the class name.
    static var reuseIdentifier: String { get }
}

// MARK: - Default protocol implementation

extension ReusableViewProtocol {
    public static var reuseIdentifier: String {
        identifier
    }
}

// MARK: - Default Conformance

extension UITableViewCell: ReusableViewProtocol {}
extension UITableViewHeaderFooterView: ReusableViewProtocol {}
extension UICollectionReusableView: ReusableViewProtocol {}

// MARK: - Table view cells

extension ReusableViewProtocol where Self: UITableViewCell {
    // MARK: - Dequeuing

    /// Returns a reusable cell of this class. Replaces the `UITableView.dequeueReusableCell(withIdentifier:for:)` method.
    /// - Parameters:
    ///   - tableView: The table view which should dequeue the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Note:
    /// Make sure the cell is registered for use in the passed table, use the `register(for:)` method.
    public static func dequeue(from tableView: UITableView,
                               at indexPath: IndexPath) -> Self {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                       for: indexPath) as? Self
        else {
            fatalError("Could not dequeue a cell for \(reuseIdentifier)! For nib-backed cells, check if the class name has been set in the nib itself.")
        }

        return cell
    }
}

// MARK: - Table view header and footer views

extension ReusableViewProtocol where Self: UITableViewHeaderFooterView {
    // MARK: - Dequeuing

    /// Returns a reusable header or footer view of this class. Replaces the `UITableView.dequeueReusableHeaderFooterView(withIdentifier:)` method.
    /// - Parameter tableView: The table view which should dequeue the view.
    /// - Note:
    /// Make sure the cell is registered for use in the passed table, use the `registerHeaderFooter(for:)` method.
    public static func dequeueHeaderFooterView(from tableView: UITableView) -> Self {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? Self else {
            fatalError("Could not dequeue a header/footer view from \(reuseIdentifier)! For nib-backed cells, check if the class name has been set in the nib itself.")
        }

        return cell
    }
}

// MARK: - Collection view cells

extension ReusableViewProtocol where Self: UICollectionViewCell {
    // MARK: - Dequeuing

    /// Returns a reusable cell of this class. Replaces the `UICollectionView.dequeueReusableCell(withIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    public static func dequeue(from collectionView: UICollectionView,
                               at indexPath: IndexPath) -> Self {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                            for: indexPath) as? Self else {
            fatalError("Could not dequeue a cell from \(reuseIdentifier)! For nib-backed cells, check if the class name has been set in the nib itself.")
        }

        return cell
    }
}

// MARK: - Collection view reusable views

extension ReusableViewProtocol where Self: UICollectionReusableView {
    // MARK: - Dequeuing

    /// Returns a reusable header view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    public static func dequeueHeader(from collectionView: UICollectionView,
                                     at indexPath: IndexPath) -> Self {
        dequeueSupplementaryView(from: collectionView,
                                 at: indexPath,
                                 of: UICollectionView.elementKindSectionHeader)
    }

    /// Returns a reusable footer view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    public static func dequeueFooter(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        dequeueSupplementaryView(from: collectionView,
                                 at: indexPath,
                                 of: UICollectionView.elementKindSectionFooter)
    }

    /// Returns a reusable supplementary view of this class. Replaces the `UITableView.dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:)` method.
    /// - Parameters:
    ///   - collectionView: The collection view which should dequeue the view.
    ///   - indexPath: The index path specifying the location of the view.
    ///   - kind: The kind of supplementary view to dequeue.
    private static func dequeueSupplementaryView(from collectionView: UICollectionView,
                                                 at indexPath: IndexPath,
                                                 of kind: String) -> Self {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: reuseIdentifier,
                                                                         for: indexPath) as? Self else {
            fatalError("Could not dequeue a supplementary view from \(reuseIdentifier)! For nib-backed cells, check if the class name has been set in the nib itself.")
        }

        return cell
    }
}


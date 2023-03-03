import Foundation
import UIKit

// MARK: - Protocol declaration

/// A utility protocol for auto-magically loading of nib backed views.
/// In order to use the protocol, you need to conform your `UIView` subclass to it.
/// Also, make sure to set the class name in the nib.
///
/// - Important:
/// - When the view is loaded in **code**, then you have to set the class name for the **View** property.
/// - When the view is loaded in **a storyboard**, you have to set the class name in the **File's owner** property.
///
/// If the view is intended to be used in a storyboard, you'll need to create an intermediate view which will contain the nib content.
/// The following sample should be used only as a basis.
/// ```
///    class FooView: UIView, NibBackedView {
///
///        private var contentView: UIView?
///
///        required init?(coder aDecoder: NSCoder) {
///            super.init(coder: aDecoder)
///            configure()
///        }
///
///        override init(frame: CGRect) {
///            super.init(frame: frame)
///            configure()
///        }
///
///        private func configure() {
///            let view = loadFromNib(useInStoryboard: true)
///            view.frame = self.bounds
///            addSubview(view)
///            contentView = view
///        }
///
///    }
/// ```
public protocol NibBackedViewProtocol: ReusableViewProtocol {
    /// Returns the nib name, equal to the class name.
    static var nibName: String { get }

    /// Returns the nib from the current bundle.
    static var nib: UINib { get }

    /// Returns the size of the view as set in the nib.
    /// - Note:
    /// When loading from nib, the size of the view is the one set in the actual nib.
    static var estimatedSize: CGSize { get }

    /// A shorthand method for loading the view from its associated nib for the current instance.
    /// - Parameter useInStoryboard: When used in a storyboard, the nib needs the **File's owner** set.
    /// - Important:
    /// - Intended for loading views both in code and storyboards.
    func loadFromNib(useInStoryboard: Bool) -> UIView

    /// A static method for loading the view from its associated nib.
    /// - Important:
    /// - Intended for loading views in code.
    static func loadFromNib() -> Self
}

// MARK: - Default protocol implementation

extension NibBackedViewProtocol {
    public static var nibName: String {
        reuseIdentifier
    }

    public static var nib: UINib {
        UINib(nibName: nibName,
              bundle: Bundle(for: self))
    }

    public func loadFromNib(useInStoryboard: Bool = false) -> UIView {
        // The owner needs to be passed only when we use the view from storyboards.
        Self.loadFromNib(owner: useInStoryboard ? self : nil)
    }

    public static func loadFromNib() -> Self {
        // The owner should be nil for views loaded in code.
        loadFromNib(owner: nil)
    }

    /// Load a view from a nib safely or throw a fatal error in debug builds.
    /// - Parameters:
    ///   - owner: An owner object of the loaded view.
    private static func loadFromNib<T>(owner: Any?) -> T {
        // When a view is loaded from a nib and used in a storyboard, we need to pass the owner to the nib instantiating method.
        // If an instance cannot be loaded, it is usually due to configuration.
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? T else {
            let errorMessage = (owner != nil)
            ? "Check if the File's owner has been to set to \(nibName) in the nib itself."
            : "Check if the class of the root view has been set to \(nibName) in the nib itself."

            fatalError("Could not instantiate a view from \(nibName)! \(errorMessage)")
        }

        // Return the loaded view.
        return view
    }

    public static var estimatedSize: CGSize {
        loadFromNib().bounds.size
    }
}

// MARK: - Table view cells

extension NibBackedViewProtocol where Self: UITableViewCell {
    // MARK: - Table cell registration

    /// Registers this cell for use in the passed table view.
    /// - Parameter tableView: The table view which should register the cell.
    public static func register(for tableView: UITableView) {
        tableView.register(nib,
                           forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Table view header and footer views

extension NibBackedViewProtocol where Self: UITableViewHeaderFooterView {
    // MARK: - Table cell registration

    /// Registers this view for use in the passed table view as a header or footer.
    /// - Parameter tableView: The table view which should register the view.
    public static func registerHeaderFooter(for tableView: UITableView) {
        tableView.register(nib,
                           forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Collection view cells

extension NibBackedViewProtocol where Self: UICollectionViewCell {
    // MARK: - Collection cell registration

    /// Registers this cell for use in the passed collection view.
    /// - Parameter collectionView: The collection view which should register the cell.
    public static func register(for collectionView: UICollectionView) {
        collectionView.register(nib,
                                forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Collection view reusable views

extension NibBackedViewProtocol where Self: UICollectionReusableView {
    // MARK: - Reusable view registration

    /// Registers this view for use in the passed table view as a header.
    /// - Parameter collectionView: The collection view which should register the view.
    public static func registerHeader(for collectionView: UICollectionView) {
        registerSupplementaryView(for: collectionView,
                                  of: UICollectionView.elementKindSectionHeader)
    }

    /// Registers this view for use in the passed table view as a header.
    /// - Parameter collectionView: The collection view which should register the view.
    public static func registerFooter(for collectionView: UICollectionView) {
        registerSupplementaryView(for: collectionView,
                                  of: UICollectionView.elementKindSectionFooter)
    }

    /// Registers this view for use in the passed table view as a header or a footer.
    /// - Parameters:
    ///   - collectionView: The collection view which should register the view.
    ///   - kind: The kind of supplementary view to register.
    private static func registerSupplementaryView(for collectionView: UICollectionView,
                                                  of kind: String) {
        collectionView.register(nib,
                                forSupplementaryViewOfKind: kind,
                                withReuseIdentifier: reuseIdentifier)
    }
}

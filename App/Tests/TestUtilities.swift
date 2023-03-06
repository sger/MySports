import Foundation

final class TestUtilities {

    /// Load a json file from xcode project.The default bundle
    /// is `Bundle.main` from test targets use `Bundle(for: type(of: self))` as
    /// parameter.
    ///
    /// - Parameters:
    ///   - file: File to load
    ///   - bundle: Bundle to access json file
    /// - Returns: A valid representation of json dictionary
    static func loadJSON(file: String, bundle: Bundle = Bundle.main) -> Any? {
        if let jsonFilePath = bundle.path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

            if let jsonData = try? Data(contentsOf: jsonFileURL) {

                if let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) {
                    return jsonDict
                }
            }
        }
        return nil
    }

    /// Load a json file from xcode project.The default bundle
    /// is `Bundle.main` from test targets use `Bundle(for: type(of: self))` as
    /// parameter.
    ///
    /// - Parameters:
    ///   - file: File to load
    ///   - bundle: Bundle to access json file
    /// - Returns: Data representation of json dictionary
    static func dataFromJSON(file: String, bundle: Bundle = Bundle.main) -> Data? {
        if let url = loadURL(file: file, bundle: bundle) {
            if let jsonData = try? Data(contentsOf: url) {
                return jsonData
            }
        }
        return nil
    }

    /// Load a json file from xcode project.The default bundle
    /// is `Bundle.main` from test targets use `Bundle(for: type(of: self))` as
    /// parameter.
    ///
    /// - Parameters:
    ///   - file: File to load
    ///   - bundle: Bundle to access json file
    /// - Returns: URL instance
    static func loadURL(file: String, bundle: Bundle = Bundle.main) -> URL? {
        if let jsonFilePath = bundle.path(forResource: file, ofType: "json") {
            return URL(fileURLWithPath: jsonFilePath)
        }
        return nil
    }
}

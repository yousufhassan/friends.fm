import Foundation
import CryptoKit

/// Print the error message to the console.
func printError(_ message: String) -> Void {
    print("ERROR: " + message)
}

/// Print the info message to the console.
func printInfo(_ message: String) -> Void {
    print("INFO: " + message)
}

/// Store the key-value pair in the user defaults object.
func storeInUserDefaults(key: String, value: Any) -> Void {
    UserDefaults.standard.set(value, forKey: key)
}

/// Retrieve the value for the `key` from the user defaults object.
func getStringFromUserDefaultsValueForKey(_ key: String) -> String {
    return UserDefaults.standard.string(forKey: key) ?? ""
}

/// Creates a directory in the File System for the file being stored at `url`, if it doesn't already exist.
func createDirectoryIfNotExists(at url: URL) throws {
    let directoryURL = url.deletingLastPathComponent()
    if !FileManager.default.fileExists(atPath: directoryURL.path) {
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
}

/// The different size options for rendering a placeholder.
enum PlaceholderSize {
    case small
    case medium
    case large
    case extraLarge
}

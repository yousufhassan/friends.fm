import Foundation
import UIImageColors
import SwiftUI

/// Returns the accent color for an image at the URL passed in, or white by default.
///
/// - Parameters:
///   - imageURLAsString: The string value for the image URL.
///
/// - Returns: The the accent color of the image as a `UIColor` or white as a default.
public func getAccentColorForImage(_ imageURLAsString: String) async throws -> UIColor {
    guard let imageURL = URL(string: imageURLAsString) else { return UIColor(.white) }
    let request = URLRequest(url: imageURL)
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let image = UIImage(data: data)
    let accentColor = image!.getColors()?.detail
    return accentColor ?? UIColor(.white)
}

/// Returns the accent color for an image at the URL passed in, or white by default.
///
/// - Parameters:
///   - image: The image as a `UIImage`.
///
/// - Returns: The the background color of the image as a `UIColor` or white as a default.
public func getBackgroundColorForImage(_ image: UIImage?) -> UIColor {
    let accentColor = image?.getColors()?.background
    return accentColor ?? UIColor(.white)
}

/// Gets the profile picture named `imageName` from disk and returns as a `UIImage`.
///
/// - Parameters:
///   - imageName: The name which the image is stored as (will be the user's Spotify ID).
public func getProfilePictureFromDisk(imageName: String) -> UIImage? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent("images/profile_pictures/\(imageName)")
    if let data = try? Data(contentsOf: fileURL) {
        return UIImage(data: data)
    }
    return nil
}

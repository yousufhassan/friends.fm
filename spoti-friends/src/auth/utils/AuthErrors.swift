import Foundation

/// Errors related to authorization.
enum AuthorizationError: Error {
    /// There was an error extracting the authorization code from the query parameters.
    case cannotExtractCode
    /// There was an error converting the browser cookie to an `SpDcCookie` object.
    case cannotConvertToSpDcCookie
    /// Was expecting an sp\_dc cookie but none was found.
    case missingSpDcCookie
    /// Was expecting a user but none was found.
    case missingUser
    /// There was an unknown authorization related error.
    case unknown
}

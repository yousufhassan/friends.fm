import Foundation

enum AuthorizationError: Error {
    case cannotExtractCode
    case cannotConvertSpDcCookie
    case missingSpDcCookie
    case missingUser
    case unknown
}

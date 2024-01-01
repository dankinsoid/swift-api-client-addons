import Foundation

enum Errors: Error {

	case unknown
    case invalidStatusCode(Int)
    case notConnected
    case invalidUTF8Data
}

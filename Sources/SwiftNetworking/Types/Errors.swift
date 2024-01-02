import Foundation

enum Errors: LocalizedError {

	case unknown
	case invalidStatusCode(Int)
	case notConnected
	case invalidUTF8Data

	var errorDescription: String? {
		switch self {
		case .unknown:
			return "Unknown error"
		case let .invalidStatusCode(code):
			return "Invalid status code: \(code)"
		case .notConnected:
			return "Not connected to the internet"
		case .invalidUTF8Data:
			return "Invalid UTF8 data"
		}
	}
}

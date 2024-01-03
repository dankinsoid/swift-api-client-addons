import Foundation

enum Errors: LocalizedError {

	case unknown
	case invalidStatusCode(Int)
	case notConnected
	case invalidUTF8Data
	case mockIsMissed(Any.Type)
	case unimplemented

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
		case let .mockIsMissed(type):
			return "Mock for \(type) is missed"
		case .unimplemented:
			return "Unimplemented"
		}
	}
}

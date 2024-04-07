import Foundation

enum Errors: LocalizedError {

	case unknown
	case notConnected
	case invalidUTF8Data
    case invalidRequest

	var errorDescription: String? {
		switch self {
		case .unknown:
			return "Unknown error"
		case .notConnected:
			return "Not connected to the internet"
		case .invalidUTF8Data:
			return "Invalid UTF8 data"
        case .invalidRequest:
            return "Invalid request"
		}
	}
}

import Foundation

public extension NetworkClient {

	func contentType(_ type: ContentType) -> NetworkClient {
		header(.contentType, set: type.rawValue)
	}
}

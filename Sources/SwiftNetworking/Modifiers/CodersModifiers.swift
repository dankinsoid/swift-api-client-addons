import Foundation
import SwiftJSON
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	/// Sets a request query encoder.
	///
	/// - Parameter encoder: A request query encoder.
	///
	/// - Returns: A new network client with the request query encoder.
	func queryEncoder(_ encoder: some QueryEncoder) -> NetworkClient {
		configs(\.queryEncoder, encoder)
	}
}

public extension NetworkClient.Configs {

	/// A request query encoder.
	var queryEncoder: any QueryEncoder {
		get { self[\.queryEncoder] ?? URLQueryEncoder() }
		set { self[\.queryEncoder] = newValue }
	}
}

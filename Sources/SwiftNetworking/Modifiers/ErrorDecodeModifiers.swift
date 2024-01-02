import Foundation

public extension NetworkClient.Configs {

	/// The error decoder used to decode errors from network responses.
	/// Gets the currently set `ErrorDecoder`, or `.none` if not set.
	/// Sets a new `ErrorDecoder`.
	var errorDecoder: ErrorDecoder {
		get { self[\.errorDecoder] ?? .none }
		set { self[\.errorDecoder] = newValue }
	}
}

public extension NetworkClient {

	/// Sets a custom error decoder for the network client.
	/// - Parameter decoder: The `ErrorDecoder` to be used for decoding errors.
	/// - Returns: An instance of `NetworkClient` configured with the specified error decoder.
	func errorDecoder(_ decoder: ErrorDecoder) -> NetworkClient {
		configs(\.errorDecoder, decoder)
	}
}

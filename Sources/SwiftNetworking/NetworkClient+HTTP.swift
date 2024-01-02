import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A struct representing an HTTP client capable of performing network requests.
public struct HTTPClient {

	/// A closure that asynchronously retrieves data and an HTTP response for a given URLRequest and network configurations.
	public var data: (URLRequest, NetworkClient.Configs) async throws -> (Data, HTTPURLResponse)

	/// Initializes a new `HTTPClient` with a custom data retrieval closure.
	/// - Parameter data: A closure that takes a `URLRequest` and `NetworkClient.Configs`, then asynchronously returns `Data` and an `HTTPURLResponse`.
	public init(_ data: @escaping (URLRequest, NetworkClient.Configs) async throws -> (Data, HTTPURLResponse)) {
		self.data = data
	}
}

public extension NetworkClient {

	/// Sets a custom HTTP client for the network client.
	/// - Parameter client: The `HTTPClient` to be used for network requests.
	/// - Returns: An instance of `NetworkClient` configured with the specified HTTP client.
	func httpClient(_ client: HTTPClient) -> NetworkClient {
		configs(\.httpClient, client)
	}
}

public extension NetworkClient.Configs {

	/// The HTTP client used for network operations.
	/// Gets the currently set `HTTPClient`, or the default `URLsession`-based client if not set.
	/// Sets a new `HTTPClient`.
	var httpClient: HTTPClient {
		get { self[\.httpClient] ?? .urlSession }
		set { self[\.httpClient] = newValue }
	}
}

public extension NetworkClient {

	/// Performs an HTTP request and processes the response using the provided serializer and `HTTPClient` from configs.
	/// - Parameters:
	///   - serializer: A `Serializer` to process the response data.
	/// - Throws: An error if the request fails, the response validation fails, or the response serialization fails.
	/// - Returns: The serialized response data of type `T`.
	func http<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) async throws -> T {
		try await withRequest { request, configs in
			do {
				configs.logger.debug("Start a request \(request.description)")
				try configs.requestValidator.validate(request, configs)
				let (data, response) = try await configs.httpClient.data(request, configs)
				configs.logger.debug("Response")
				do {
					try configs.httpResponseValidator.validate(response, data, configs)
					return try serializer.serialize(data, configs)
				} catch {
					if let failure = configs.errorDecoder.decodeError(data, configs) {
						configs.logger.debug("Response failed with error: `\(error.humanReadable)`")
						throw failure
					}
					throw error
				}
			} catch {
				configs.logger.error("Request \(request.description) failed with error: `\(error.humanReadable)`")
				throw error
			}
		}
	}
}

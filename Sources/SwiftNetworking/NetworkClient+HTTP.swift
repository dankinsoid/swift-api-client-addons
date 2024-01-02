import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct HTTPClient {

	public var data: (URLRequest, NetworkClient.Configs) async throws -> (Data, HTTPURLResponse)

	public init(_ data: @escaping (URLRequest, NetworkClient.Configs) async throws -> (Data, HTTPURLResponse)) {
		self.data = data
	}
}

public extension NetworkClient {

	func httpClient(_ client: HTTPClient) -> NetworkClient {
		configs(\.httpClient, client)
	}
}

public extension NetworkClient.Configs {

	var httpClient: HTTPClient {
		get { self[\.httpClient] ?? .urlSession }
		set { self[\.httpClient] = newValue }
	}
}

public extension NetworkClient {

	func http<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) async throws -> T {
		try await withRequest { request, configs in
			do {
				configs.logger.debug("Start a request \(request.description)")
				try configs.requestValidator.validate(request)
				let (data, response) = try await configs.httpClient.data(request, configs)
				configs.logger.debug("Response")
				do {
					try configs.httpResponseValidator.validate(response, data)
					return try serializer.serialize(data, configs)
				} catch {
					if let failure = configs.errorDecoder.decodeError(from: data) {
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

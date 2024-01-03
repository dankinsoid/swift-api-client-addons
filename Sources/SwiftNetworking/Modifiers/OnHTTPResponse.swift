import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension NetworkClient {

	/// Sets a closure to be called when a response is received.
	func onHTTPResponse(_ action: @escaping (HTTPURLResponse, Data, NetworkClient.Configs) -> Void) -> NetworkClient {
		configs {
			let client = $0.httpClient
			$0.httpClient = HTTPClient { req, configs in
				let (data, response) = try await client.data(req, configs)
				action(response, data, configs)
				return (data, response)
			}
		}
	}

	func mapHTTPResponse(_ action: @escaping (HTTPURLResponse, Data, NetworkClient.Configs) async throws -> (Data, HTTPURLResponse)) -> NetworkClient {
		configs {
			let client = $0.httpClient
			$0.httpClient = HTTPClient { req, configs in
				let (data, response) = try await client.data(req, configs)
				return try await action(response, data, configs)
			}
		}
	}
}

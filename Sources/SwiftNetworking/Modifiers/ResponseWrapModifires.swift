import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	/// Configures the network client to transform the response data using a provided mapping function.
	/// - Parameter mapper: A closure that takes `Data` and returns transformed `Data`.
	/// - Returns: An instance of `NetworkClient` configured with the specified response data transformation.
	/// - Note: This modifier is applied to both `HTTPClient` and `WebSocketClient`.
	func mapResponse(_ mapper: @escaping (Data) throws -> Data) -> NetworkClient {
		configs {
			let httpClient = $0.httpClient
			$0.httpClient = HTTPClient { request, configs in
				var (data, response) = try await httpClient.data(request, configs)
				data = try mapper(data)
				return (data, response)
			}

			let webSocketClient = $0.webSocketClient
			$0.webSocketClient = WebSocketClient { request, configs in
				try webSocketClient.connect(request, configs).map(mapper)
			}
		}
	}

	/// Configures the network client to use a custom decoder as specified by the provided mapping function.
	/// - Parameter mapper: A closure that takes an existing `DataDecoder` and returns a modified `DataDecoder`.
	/// - Returns: An instance of `NetworkClient` configured with the specified decoder.
	func mapDecoder(_ mapper: @escaping (any DataDecoder) -> any DataDecoder) -> NetworkClient {
		configs {
			$0.bodyDecoder = mapper($0.bodyDecoder)
		}
	}
}

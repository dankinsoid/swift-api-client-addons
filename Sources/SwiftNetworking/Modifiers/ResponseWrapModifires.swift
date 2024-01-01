import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

//	func mapResponse(_ mapper: @escaping (Data) throws -> Data) -> NetworkClient {
//		configs {
//			$0.httpClient = MapResponseClient(
//				base: $0.httpClient,
//				mapper: mapper
//			)
//			$0.webSocketClient = MapStreamClient(
//				base: $0.webSocketClient,
//				mapper: mapper
//			)
//		}
//	}

	func mapDecoder(_ mapper: @escaping (any DataDecoder) -> any DataDecoder) -> NetworkClient {
		configs {
			$0.bodyDecoder = mapper($0.bodyDecoder)
		}
	}
}

//private struct MapStreamClient: WebSocketClient {
//
//	let base: WebSocketClient
//	let mapper: (Data) throws -> Data
//
//	func stream(for request: URLRequest) throws -> AnyAsyncSequence<Data> {
//		try base.stream(for: request).map(mapper).eraseToAnyAsyncSequence()
//	}
//}
//
//private struct MapResponseClient: HTTPClient {
//
//	let base: HTTPClient
//	let mapper: (Data) throws -> Data
//
//	func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
//		var (data, response) = try await base.data(for: request)
//		data = try mapper(data)
//		return (data, response)
//	}
//}

import Foundation
import Starscream
import VDCodable

public protocol StreamClient {

	func stream(for request: URLRequest) throws -> AnyAsyncSequence<Data>
}

public extension NetworkClient {

	func streamClient(_ client: some StreamClient) -> NetworkClient {
		configs(\.streamClient, client)
	}
}

public extension NetworkClient.Configs {

	var streamClient: StreamClient {
		get { self[\.streamClient] ?? .socket }
		set { self[\.streamClient] = newValue }
	}
}

public extension StreamClient where Self == SocketClient {

	static var socket: Self {
		SocketClient()
	}
}

public struct SocketClient: StreamClient {

	public func stream(for request: URLRequest) throws -> AnyAsyncSequence<Data> {
		var urlRequest = request
		if let url = urlRequest.url, url.absoluteString.hasPrefix("http") {
			urlRequest.url = URL(string: "ws" + url.absoluteString.dropFirst(4)) ?? url
		}
		return WebSocket(request: urlRequest, useCustomEngine: true)
			.stream
			.eraseToAnyAsyncSequence()
	}
}

public extension NetworkClient {

	func stream(
		fileID: String = #fileID,
		line: UInt = #line
	) throws -> AnyAsyncSequence<Data> {
		try withRequest { request, configs in
			do {
				configs.logger.debug("Start a stream \(request.description)")
				return try configs.streamClient.stream(for: request)
			} catch {
				configs.logger.error("Stream \(request.description) failed with error: `\(error.localizedDescription)`")
				throw error
			}
		}
	}

	func jsonStream(
		fileID: String = #fileID,
		line: UInt = #line
	) throws -> AnyAsyncSequence<JSON> {
		try stream(fileID: fileID, line: line)
			.map {
				try JSON(from: $0)
			}
			.eraseToAnyAsyncSequence()
	}

	func decodableStream<Output: Decodable>(
		_ type: Output.Type = Output.self,
		fileID: String = #fileID,
		line: UInt = #line
	) throws -> AnyAsyncSequence<Output> {
		try withConfigs { configs in
			try stream(fileID: fileID, line: line)
				.map {
					do {
						return try configs.bodyDecoder.decode(type, from: $0)
					} catch {
						configs.logger.error("Data decoding failed with error: `\(error.localizedDescription)`")
						throw error
					}
				}
				.eraseToAnyAsyncSequence()
		}
	}
}

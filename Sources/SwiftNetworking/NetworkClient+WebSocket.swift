import Foundation
import Starscream
import VDCodable

public struct WebSocketClient {

	public var connect: (URLRequest, NetworkClient.Configs) throws -> WebSocketChannel<Data>

	public init(_ connect: @escaping (URLRequest, NetworkClient.Configs) -> WebSocketChannel<Data>) {
		self.connect = connect
	}
}

public extension NetworkClient {

	func webSocketClient(_ client: WebSocketClient) -> NetworkClient {
		configs(\.webSocketClient, client)
	}
}

public extension NetworkClient.Configs {

	var webSocketClient: WebSocketClient {
		get { self[\.webSocketClient] ?? .default }
		set { self[\.webSocketClient] = newValue }
	}
}

public extension NetworkClient {

	func webSocket<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) throws -> WebSocketChannel<T> {
		try withRequest { request, configs in
			do {
				try configs.requestValidator.validate(request)
				configs.logger.debug("Start a stream \(request.description)")
				return try configs.webSocketClient.connect(request, configs).map {
					do {
						return try serializer.serialize($0, configs)
					} catch {
						if let failure = configs.errorDecoder.decodeError(from: $0) {
							configs.logger.debug("Response failed with error: `\(error.humanReadable)`")
							throw failure
						}
						configs.logger.error("Response decoding failed with error: `\(error.humanReadable)`")
						throw error
					}
				}
			} catch {
				configs.logger.error("Socket \(request.description) failed with error: `\(error.humanReadable)`")
				throw error
			}
		}
	}
}

public extension WebSocketClient {

	static var `default`: Self {
		.default(pingInterval: 15)
	}

	static func `default`(pingInterval: Double?) -> Self {
		WebSocketClient { request, _ in
			var urlRequest = request
			if let url = urlRequest.url, url.absoluteString.hasPrefix("http") {
				urlRequest.url = URL(string: "ws" + url.absoluteString.dropFirst(4)) ?? url
			}
			let stream = WebSocketStream(
				WebSocket(request: urlRequest, useCustomEngine: true),
				pingInterval: pingInterval
			)
			return WebSocketChannel(stream, sendData: stream.send, sendString: stream.send)
		}
	}
}

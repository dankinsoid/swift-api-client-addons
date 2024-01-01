import Foundation
import Starscream
import VDCodable

public struct WebSocketClient {

    private let _connect: (URLRequest) throws -> WebSocketChannel<Data>

    public init(_ connect: @escaping (URLRequest) -> WebSocketChannel<Data>) {
        self._connect = connect
    }

    public func connect(with request: URLRequest) throws -> WebSocketChannel<Data> {
        try _connect(request)
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
				configs.logger.debug("Start a stream \(request.description)")
                return try configs.webSocketClient.connect(with: request).map {
                    try serializer.serialize($0, configs)
                }
			} catch {
				configs.logger.error("Socket \(request.description) failed with error: `\(error.localizedDescription)`")
				throw error
			}
		}
	}
}

public extension WebSocketClient {

    static var `default`: Self {
        .default(pingInterval: 15)
    }

    static func `default`(pingInterval: Double) -> Self {
        WebSocketClient { request in
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

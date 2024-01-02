import Foundation
import Starscream
import VDCodable

/// A struct representing a WebSocket client for establishing WebSocket connections.
public struct WebSocketClient {

	/// A closure that establishes a WebSocket connection and returns a `WebSocketChannel` for data communication.
	public var connect: (URLRequest, NetworkClient.Configs) throws -> WebSocketChannel<Data>

	/// Initializes a new `WebSocketClient` with a custom connection closure.
	/// - Parameter connect: A closure that takes a `URLRequest` and `NetworkClient.Configs`, then returns a `WebSocketChannel` for the WebSocket connection.
	public init(_ connect: @escaping (URLRequest, NetworkClient.Configs) throws -> WebSocketChannel<Data>) {
		self.connect = connect
	}
}

public extension NetworkClient {

	/// Sets a custom WebSocket client for the network client.
	/// - Parameter client: The `WebSocketClient` to be used for WebSocket connections.
	/// - Returns: An instance of `NetworkClient` configured with the specified WebSocket client.
	func webSocketClient(_ client: WebSocketClient) -> NetworkClient {
		configs(\.webSocketClient, client)
	}
}

public extension NetworkClient.Configs {

	/// The WebSocket client used for WebSocket connections.
	/// Gets the currently set `WebSocketClient`, or the default client if not set.
	/// Sets a new `WebSocketClient`.
	var webSocketClient: WebSocketClient {
		get { self[\.webSocketClient] ?? .default }
		set { self[\.webSocketClient] = newValue }
	}
}

public extension NetworkClient {

	/// Establishes a WebSocket connection and returns a `WebSocketChannel` for data communication.
	/// - Parameters:
	///   - serializer: A `Serializer` to process the response data.
	/// - Throws: An error if the connection fails or the request validation fails.
	/// - Returns: A `WebSocketChannel` for the serialized response data of type `T`.
	func webSocket<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) throws -> WebSocketChannel<T> {
		try withRequest { request, configs in
			do {
				try configs.requestValidator.validate(request, configs)
				configs.logger.debug("Start a stream \(request.description)")
				return try configs.webSocketClient.connect(request, configs).map {
					do {
						return try serializer.serialize($0, configs)
					} catch {
						if let failure = configs.errorDecoder.decodeError($0, configs) {
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

	/// A convenient static property to access the default WebSocket client.
	static var `default`: Self {
		.default(pingInterval: 15)
	}

	/// Creates a default `WebSocketClient` with an optional ping interval.
	/// - Parameter pingInterval: An optional double specifying the ping interval in seconds. If nil is passed, no ping will be sent.
	/// - Returns: A `WebSocketClient` with default configuration and optional ping interval.
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

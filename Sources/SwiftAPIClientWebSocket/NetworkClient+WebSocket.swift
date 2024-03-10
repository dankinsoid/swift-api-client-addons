import Foundation
import Starscream
@_exported import SwiftAPIClient

/// A struct representing a WebSocket client for establishing WebSocket connections.
public struct WebSocketClient {

	/// A closure that establishes a WebSocket connection and returns a `WebSocketChannel` for data communication.
	public var connect: (URLRequest, APIClient.Configs) throws -> WebSocketChannel<Data>

	/// Initializes a new `WebSocketClient` with a custom connection closure.
	/// - Parameter connect: A closure that takes a `URLRequest` and `APIClient.Configs`, then returns a `WebSocketChannel` for the WebSocket connection.
	public init(_ connect: @escaping (URLRequest, APIClient.Configs) throws -> WebSocketChannel<Data>) {
		self.connect = connect
	}
}

public extension APIClient {

	/// Sets a custom WebSocket client for the network client.
	/// - Parameter client: The `WebSocketClient` to be used for WebSocket connections.
	/// - Returns: An instance of `APIClient` configured with the specified WebSocket client.
	func webSocketClient(_ client: WebSocketClient) -> APIClient {
		configs(\.webSocketClient, client)
	}
}

public extension APIClient.Configs {

	/// The WebSocket client used for WebSocket connections.
	/// Gets the currently set `WebSocketClient`, or the default client if not set.
	/// Sets a new `WebSocketClient`.
	var webSocketClient: WebSocketClient {
		get { self[\.webSocketClient] ?? .default }
		set { self[\.webSocketClient] = newValue }
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

public extension APIClientCaller where Result == WebSocketChannel<Value>, Response == Data {

	static var webSocket: APIClientCaller {
		APIClientCaller { uuid, request, configs, serialize in
			do {
				return try configs.webSocketClient.connect(request, configs).map { data in
					do {
						let result = try serialize(data) {}
						if !configs.loggingComponents.isEmpty {
							let message = configs.loggingComponents.responseMessage(
								uuid: uuid,
								data: data
							)
							configs.logger.error("\(message)")
						}
						return result
					} catch {
						if !configs.loggingComponents.isEmpty {
							let message = configs.loggingComponents.responseMessage(
								uuid: uuid,
								data: data,
								error: error
							)
							configs.logger.error("\(message)")
						}
						throw error
					}
				}
			} catch {
				if !configs.loggingComponents.isEmpty {
					let message = configs.loggingComponents.errorMessage(uuid: uuid, error: error)
					configs.logger.error("\(message)")
				}
				throw error
			}
		} mockResult: { value in
			WebSocketChannel([value].async) { _ in
			} sendString: { _ in
			}
		}
	}
}

#if canImport(Combine)
import Combine

extension WebSocketChannel: Publisher {

	public typealias Output = Element
	public typealias Failure = Error

	public func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
		Publishers.Task<Output, Failure> { send in
			for try await output in self {
				try Task.checkCancellation()
				send(output)
			}
		}
		.receive(subscriber: subscriber)
	}
}
#endif

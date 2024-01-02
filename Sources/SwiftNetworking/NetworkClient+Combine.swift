#if canImport(Combine)
import Combine
import Foundation

public extension NetworkClient {

	/// Creates a publisher that performs a http network request and decodes the response body.
	func httpPublisher<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) -> AnyPublisher<T, Error> {
		Publishers.Task<T, Error> {
			try await http(serializer, fileID: fileID, line: line)
		}
		.eraseToAnyPublisher()
	}
}

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

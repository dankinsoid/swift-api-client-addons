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
		Publishers.Create { onOutput, onCompletion in
			Task {
				do {
					try await onOutput(http(serializer, fileID: fileID, line: line))
				} catch is CancellationError {
					onCompletion(.finished)
				} catch {
					onCompletion(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
	}

	/// Creates a publisher that performs a web socket network connection and decodes the response body.
	func webSocketPublisher<T>(
		_ serializer: Serializer<Data, T>,
		fileID: String = #fileID,
		line: UInt = #line
	) -> AnyPublisher<T, Error> {
		Publishers.Create { onOutput, onCompletion in
			Task {
				do {
					for try await output in try webSocket(serializer, fileID: fileID, line: line) {
						try Task.checkCancellation()
						onOutput(output)
					}
				} catch is CancellationError {
					onCompletion(.finished)
				} catch {
					onCompletion(.failure(error))
				}
			}
		}
		.eraseToAnyPublisher()
	}
}
#endif

#if canImport(Combine)
import Combine
import Foundation

public extension NetworkClient {

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

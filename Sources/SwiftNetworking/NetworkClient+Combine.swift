#if canImport(Combine)
import Foundation
import Combine

extension NetworkClient {

    public func httpPublisher<T>(
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

    public func webSocketPublisher<T>(
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

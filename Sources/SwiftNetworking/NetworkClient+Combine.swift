#if canImport(Combine)
import Combine
import Foundation

public extension NetworkClientCaller where Result == AnyPublisher<Value, Error>, Response == Data {

	static var httpPublisher: NetworkClientCaller {
		NetworkClientCaller<Response, Value, AsyncValue<Value>>.http.map { value in
			Publishers.Task {
				try await value()
			}
			.eraseToAnyPublisher()
		}
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

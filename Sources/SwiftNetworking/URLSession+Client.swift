import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension HTTPClient {

	/// Creates an `HTTPClient` that uses a specified `URLSession` for network requests.
	/// - Parameter session: The `URLSession` to use for network requests.
	/// - Returns: An `HTTPClient` that uses the given `URLSession` to fetch data.
	static func urlSession(_ session: URLSession) -> Self {
		HTTPClient { request, _ in
			#if os(Linux)
			return try await asyncMethod(with: request, session.dataTask)
			#else
			if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
				let (data, response) = try await session.data(for: request)
				guard let httpResponse = response.http else {
					throw Errors.responseTypeIsNotHTTP
				}
				return (data, httpResponse)
			} else {
				return try await asyncMethod(with: request, session.dataTask)
			}
			#endif
		}
	}

	/// A static property to get an `HTTPClient` that uses the shared `URLSession`.
	static var urlSession: Self {
		urlSession(.shared)
	}
}

private func asyncMethod<T, S: URLSessionTask>(
	with urlRequest: URLRequest,
	_ method: @escaping (
		URLRequest, @escaping @Sendable (T?, URLResponse?, Error?) -> Void
	) -> S
) async throws -> (T, HTTPURLResponse) {
	try await withCheckedThrowingContinuation { continuation in
		method(urlRequest) { t, response, error in
			if let t, let response = response?.http {
				continuation.resume(returning: (t, response))
			} else {
				continuation.resume(throwing: error ?? Errors.unknown)
			}
		}
		.resume()
	}
}

private final class URLSessionDelegateProxy: NSObject, URLSessionDelegate {}

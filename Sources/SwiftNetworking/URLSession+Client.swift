import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension HTTPClient {

	static func urlSession(_ session: URLSession) -> Self {
        HTTPClient { request in
#if os(Linux)
            return try await asyncMethod(with: request, session.dataTask)
#else
            if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
                let (data, response) = try await session.data(for: request)
                return (data, response.http)
            } else {
                return try await asyncMethod(with: request, session.dataTask)
            }
#endif
        }
	}

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
			if let t, let response {
                continuation.resume(returning: (t, response.http))
			} else {
				continuation.resume(throwing: error ?? Errors.unknown)
			}
		}
		.resume()
	}
}

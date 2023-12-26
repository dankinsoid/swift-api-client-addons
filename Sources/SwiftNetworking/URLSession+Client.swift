import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension HTTPClient where Self == URLSessionCore {
    
    public static func urlSession(_ session: URLSession) -> Self {
        URLSessionCore(session: session)
    }

    public static var urlSession: Self {
        urlSession(.shared)
    }
}

struct DecodableErrorCore<Failure: Decodable & Error>: HTTPClient {
    
    let base: HTTPClient
    let decoder: any DataDecoder
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await base.data(for: request)
        if 
            let code = (response as? HTTPURLResponse)?.statusCode,
            code > 299 || code < 200,
            let failure = try? decoder.decode(Failure.self, from: data) 
        {
            throw failure
        }
        return (data, response)
    }
}

public struct URLSessionCore: HTTPClient {
    
    public let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
#if os(Linux)
        return try await asyncMethod(with: request, session.dataTask)
#else
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
            return try await session.data(for: request)
        } else {
            return try await asyncMethod(with: request, session.dataTask)
        }
#endif
    }
}

private func asyncMethod<T, S: URLSessionTask>(
    with urlRequest: URLRequest,
    _ method: @escaping (
        URLRequest, @escaping @Sendable (T?, URLResponse?, Error?) -> Void
    ) -> S
) async throws -> (T, URLResponse) {
    try await withCheckedThrowingContinuation { continuation in
        method(urlRequest) { t, response, error in
            if let t = t, let response = response {
                continuation.resume(returning: (t, response))
            }
            else {
                continuation.resume(throwing: error ?? Errors.unknown)
            }
        }
        .resume()
    }
}

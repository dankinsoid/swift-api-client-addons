import Foundation
import SwiftNetworking
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension HTTPClient {

	static func test() -> HTTPClient {
		HTTPClient { request, configs in
			try configs.testHTTPClient(request, configs)
		}
	}
}

private extension NetworkClient.Configs {

	var testHTTPClient: (URLRequest, NetworkClient.Configs) throws -> (Data, HTTPURLResponse) {
		get { self[\.testHTTPClient] ?? { _, _ in throw Unimplemented() } }
		set { self[\.testHTTPClient] = newValue }
	}
}

private struct Unimplemented: Error {}

extension NetworkClient {

	func httpTest(
		test: @escaping (URLRequest, NetworkClient.Configs) throws -> Void
	) async throws {
		try await configs(\.testHTTPClient) {
			try test($0, $1)
			return (Data(), HTTPURLResponse())
		}
		.call(.http, as: .void)
	}
}

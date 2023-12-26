import Foundation
import Reachability

public extension NetworkClient {

	func waitForConnection(
		retryLimit: Int? = nil,
		reachabilityService: ReachabilityService = .default
	) -> NetworkClient {
		configs {
			$0.httpClient = RetryOnReachabilityClient(
				base: $0.httpClient,
				retryLimit: retryLimit,
				reachabilityService: reachabilityService
			)
		}
	}
}

private struct RetryOnReachabilityClient: HTTPClient {

	let base: HTTPClient
	let retryLimit: Int?
	let reachabilityService: ReachabilityService

	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		await reachabilityService.waitReachable()
		var count = 0
		//        let didEnterBackground = DefaultWasInBackgroundService()
		func needRetry() -> Bool {
			guard !reachabilityService.isReachable else {
				return false
			} // || didEnterBackground.wasInBackground
			if let retryLimit {
				return count <= retryLimit
			}
			return true
		}

		func retry() async throws -> (Data, URLResponse) {
			count += 1
			return try await self.data(for: request)
		}

		let response: URLResponse
		let data: Data
		do {
			(data, response) = try await retry()
		} catch {
			if needRetry() {
				return try await retry()
			}
			throw error
		}
		if !response.isStatusCodeValid, needRetry() {
			return try await retry()
		}
		return (data, response)
	}
}

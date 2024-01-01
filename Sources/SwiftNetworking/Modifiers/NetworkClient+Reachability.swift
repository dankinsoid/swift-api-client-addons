import Foundation
import Reachability
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	func waitForConnection(
		retryLimit: Int? = nil,
		reachabilityService: ReachabilityService = .default
	) -> NetworkClient {
		configs { configs in
            let client = configs.httpClient
            configs.httpClient = HTTPClient { request in
                await reachabilityService.waitReachable()
                var count = 0
                func needRetry() -> Bool {
                    guard !reachabilityService.isReachable else {
                        return false
                    }
                    if let retryLimit {
                        return count <= retryLimit
                    }
                    return true
                }
                
                func retry() async throws -> (Data, HTTPURLResponse) {
                    count += 1
                    return try await client.data(for: request)
                }
                
                let response: HTTPURLResponse
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
	}
}

import Foundation
import Reachability

private struct RetryOnReachabilityClient: HTTPClient {

    let base: HTTPClient
    let reachabilityService: ReachabilityService

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        await reachabilityService.waitReachable()
//        let didEnterBackground = DefaultWasInBackgroundService()
        func needRetry() -> Bool {
            !reachabilityService.isReachable //|| didEnterBackground.wasInBackground
        }
        func retry() async throws -> (Data, URLResponse) {
            try await self.data(for: request)
        }

        let response: URLResponse
        let data: Data
        do {
            (data, response) = try await base.data(for: request)
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

extension URLResponse {

    var isStatusCodeValid: Bool {
        if let response = self as? HTTPURLResponse {
            return response.statusCode >= 200 && response.statusCode < 300
        }
        return false
    }
}

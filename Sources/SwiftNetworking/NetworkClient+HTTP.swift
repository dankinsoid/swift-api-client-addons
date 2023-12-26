import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol HTTPClient {
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkClient.Configs {
    
    public var httpClient: HTTPClient {
        get { self[\.httpClient] ?? .urlSession }
        set { self[\.httpClient] = newValue }
    }
}

extension NetworkClient {
    
    public func httpClient(_ client: some HTTPClient) -> NetworkClient {
        configs(\.httpClient, client)
    }
}

extension NetworkClient {

    public func response(
        fileID: String = #fileID,
        line: UInt = #line
    ) async throws -> (Data, URLResponse) {
        try await withRequest { request, configs in
            do {
                configs.logger.debug("Start a request \(request.description)")
                let (data, response) = try await configs.httpClient.data(for: request)
                configs.logger.debug("Response")
                return (data, response)
            } catch {
                configs.logger.error("Request \(request.description) failed with error: `\(error.localizedDescription)`")
                throw error
            }
        }
    }
}

extension NetworkClient {

    public func data(
        fileID: String = #fileID,
        line: UInt = #line
    ) async throws -> Data {
        try await response(fileID: fileID, line: line).0
    }

    public func json(
        fileID: String = #fileID,
        line: UInt = #line
    ) async throws -> JSON {
        try await JSON(from: response(fileID: fileID, line: line).0)
    }

    public func decodable<Output: Decodable>(
        _ type: Output.Type = Output.self,
        fileID: String = #fileID,
        line: UInt = #line
    ) async throws -> Output {
        let data = try await self.data(fileID: fileID, line: line)
        return try withConfigs { configs in
            do {
                return try configs.bodyDecoder.decode(type, from: data)
            } catch {
                configs.logger.error("Data decoding failed with error: `\(error.localizedDescription)`")
                throw error
            }
        }
    }
}

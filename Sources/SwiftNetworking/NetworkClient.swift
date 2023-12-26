import Foundation
@_exported import SimpleCoders
@_exported import VDCodable
import Logging
@_exported import MultipartFormDataKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension NetworkClient {

    public func contentType(_ type: ContentType) -> NetworkClient {
        header("Content-Type", type.rawValue)
    }

    public func bodyEncoder<T: ContentEncoder>(_ encoder: T) -> NetworkClient {
        contentType(type(of: encoder).contentType)
            .configs(\.bodyEncoder, encoder)
    }

    public func log(level: Logger.Level) -> NetworkClient {
        configs(\.logLevel, level)
    }
}

enum Errors: Error {
    
    case unknown
}

public struct NetworkClient {

    private var _createRequest: (Configs) throws -> URLRequest
    private var modifyConfigs: (inout Configs) -> Void = { _ in }

    public init(
        baseURL: URL
    ) {
        _createRequest = { _ in
            URLRequest(url: baseURL)
        }
    }

    public init(
        request: URLRequest
    ) {
        _createRequest = { _ in
            request
        }
    }

    public func configs<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>, _ value: T) -> NetworkClient {
        configs {
            $0[keyPath: keyPath] = value
        }
    }
    
    public func configs(_ configs: @escaping (inout Configs) -> Void) -> NetworkClient {
        var result = self
        result.modifyConfigs = { [modifyConfigs] in
            modifyConfigs(&$0)
            configs(&$0)
        }
        return result
    }

    public func modifyRequest(_ modifier: @escaping (inout URLRequest) throws -> Void) -> NetworkClient {
        modifyRequest { req, _ in
            try modifier(&req)
        }
    }
    
    public func modifyRequest(_ modifier: @escaping (inout URLRequest, Configs) throws -> Void) -> NetworkClient {
        var result = self
        result._createRequest = { [_createRequest] configs in
            var request = try _createRequest(configs)
            try modifier(&request, configs)
            return request
        }
        return result
    }

    public func withRequest<T>(_ operation: (URLRequest, Configs) throws -> T) throws -> T {
        let (request, configs) = try createRequest()
        return try operation(request, configs)
    }

    public func withRequest<T>(_ operation: (URLRequest, Configs) async throws -> T) async throws -> T {
        let (request, configs) = try createRequest()
        return try await operation(request, configs)
    }
    
    public func withConfigs<T>(_ operation: (Configs) throws -> T) rethrows -> T {
        var configs = Configs()
        modifyConfigs(&configs)
        return try operation(configs)
    }

    public func withConfigs<T>(_ operation: (Configs) async throws -> T) async rethrows -> T {
        var configs = Configs()
        modifyConfigs(&configs)
        return try await operation(configs)
    }

    private func createRequest() throws -> (URLRequest, Configs) {
        var configs = Configs()
        modifyConfigs(&configs)
        do {
            return try (_createRequest(configs), configs)
        } catch {
            configs.logger.error("Request creation failed with error: `\(error.localizedDescription)`")
            throw error
        }
    }
}

extension NetworkClient {

    public func header(_ field: String, _ value: String) -> NetworkClient {
        modifyRequest {
            $0.setValue(value, forHTTPHeaderField: field)
        }
    }
    
    public func path(_ components: any CustomStringConvertible...) -> NetworkClient {
        path(components)
    }
    
    public func path(_ components: [any CustomStringConvertible]) -> NetworkClient {
        modifyRequest {
            for component in components {
                $0.url?.appendPathComponent(component.description)
            }
        }
    }
    
    public func method(_ method: HTTPMethod) -> NetworkClient {
        modifyRequest {
            $0.httpMethod = method.rawValue
        }
    }

    public func body(_ value: any Encodable) -> NetworkClient {
        body {
            try $0.bodyEncoder.encode(value)
        }
    }

    public func body(_ data: @escaping @autoclosure () throws -> Data) -> NetworkClient {
        body { _ in try data() }
    }

    public func body(_ data: @escaping (Configs) throws -> Data) -> NetworkClient {
        modifyRequest { req, configs in
            req.httpBodyStream = nil
            req.httpBody = try data(configs)
        }
    }

    public func body(
        multiparts partParams: [MultipartFormData.PartParam],
        boundary: String? = nil
    ) -> NetworkClient {
        body(
            try MultipartFormData.Builder.build(
                with: partParams,
                willSeparateBy: boundary ?? RandomBoundaryGenerator.generate()
            ).body
        )
        .contentType(.multipart(.formData))
    }

    public func body(_ json: JSON) -> NetworkClient {
        body(json.data)
            .contentType(.application(.json))
    }

    public func query(_ items: any Encodable) -> NetworkClient {
        query {
            try $0.queryEncoder.encode(items)
        }
    }
    
    public func query(_ items: @escaping @autoclosure () throws -> [URLQueryItem]) -> NetworkClient {
        query { _ in
            try items()
        }
    }

    public func query(_ items: @escaping (Configs) throws -> [URLQueryItem]) -> NetworkClient {
        modifyRequest { req, configs in
            if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
                try req.url?.append(queryItems: items(configs))
            } else if
                let url = req.url,
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            {
                if components.queryItems == nil {
                    components.queryItems = []
                }
                try components.queryItems?.append(contentsOf: items(configs))
                req.url = components.url ?? url
            }
        }
    }

    public func query(_ json: [String: JSON]) -> NetworkClient {
        query(
            json.sorted(by: { $0.key < $1.key })
                .map { URLQueryItem(name: $0.key, value: $0.value.description) }
        )
    }

    public func query(_ field: String, _ value: CustomStringConvertible) -> NetworkClient {
        query([field: .string(value.description)])
    }
}

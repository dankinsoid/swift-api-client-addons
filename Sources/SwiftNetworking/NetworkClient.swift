import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

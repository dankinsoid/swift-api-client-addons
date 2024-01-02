import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A network client for handling url requests with configurable request and configuration handling.
public struct NetworkClient {

	private var _createRequest: (Configs) throws -> URLRequest
	private var modifyConfigs: (inout Configs) -> Void = { _ in }

	/// Initializes a new network client with a base URL for requests.
	/// - Parameter baseURL: The base URL to be used for creating requests.
	public init(
		baseURL: URL
	) {
		_createRequest = { _ in
			URLRequest(url: baseURL)
		}
	}

	/// Initializes a new network client with a predefined URLRequest.
	/// - Parameter request: The URLRequest to be used for all requests.
	public init(
		request: URLRequest
	) {
		_createRequest = { _ in
			request
		}
	}

	/// Configures the client with specific configuration values.
	/// - Parameters:
	///   - keyPath: The key path to the configuration property to be modified.
	///   - value: The new value for the specified configuration property.
	/// - Returns: An instance of `NetworkClient` with updated configurations.
	public func configs<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>, _ value: T) -> NetworkClient {
		configs {
			$0[keyPath: keyPath] = value
		}
	}

	/// Configures the client with a closure that modifies its configurations.
	/// - Parameter configs: A closure that takes `inout Configs` and modifies them.
	/// - Returns: An instance of `NetworkClient` with updated configurations.
	public func configs(_ configs: @escaping (inout Configs) -> Void) -> NetworkClient {
		var result = self
		result.modifyConfigs = { [modifyConfigs] in
			modifyConfigs(&$0)
			configs(&$0)
		}
		return result
	}

	/// Modifies the URLRequest using the provided closure.
	/// - Parameter modifier: A closure that takes `inout URLRequest` and modifies it.
	/// - Returns: An instance of `NetworkClient` with a modified URLRequest.
	public func modifyRequest(_ modifier: @escaping (inout URLRequest) throws -> Void) -> NetworkClient {
		modifyRequest { req, _ in
			try modifier(&req)
		}
	}

	/// Modifies the URLRequest using the provided closure, with access to current configurations.
	/// - Parameter modifier: A closure that takes `inout URLRequest` and `Configs`, and modifies the URLRequest.
	/// - Returns: An instance of `NetworkClient` with a modified URLRequest.
	public func modifyRequest(_ modifier: @escaping (inout URLRequest, Configs) throws -> Void) -> NetworkClient {
		var result = self
		result._createRequest = { [_createRequest] configs in
			var request = try _createRequest(configs)
			try modifier(&request, configs)
			return request
		}
		return result
	}

	/// Executes an operation with the current URLRequest and configurations.
	/// - Parameter operation: A closure that takes `URLRequest` and `Configs` and returns a generic type `T`.
	/// - Throws: Rethrows any errors encountered within the closure.
	/// - Returns: The result of the closure of type `T`.
	public func withRequest<T>(_ operation: (URLRequest, Configs) throws -> T) throws -> T {
		let (request, configs) = try createRequest()
		return try operation(request, configs)
	}

	/// Asynchronously executes an operation with the current URLRequest and configurations.
	/// - Parameter operation: A closure that takes `URLRequest` and `Configs`, and returns a generic type `T`.
	/// - Throws: Rethrows any errors encountered within the closure.
	/// - Returns: The result of the closure of type `T`.
	public func withRequest<T>(_ operation: (URLRequest, Configs) async throws -> T) async throws -> T {
		let (request, configs) = try createRequest()
		return try await operation(request, configs)
	}

	/// Executes an operation with the current configurations.
	/// - Parameter operation: A closure that takes `Configs` and returns a generic type `T`.
	/// - Rethrows: Rethrows any errors encountered within the closure.
	/// - Returns: The result of the closure of type `T`.
	public func withConfigs<T>(_ operation: (Configs) throws -> T) rethrows -> T {
		var configs = Configs()
		modifyConfigs(&configs)
		return try operation(configs)
	}

	/// Asynchronously executes an operation with the current configurations.
	/// - Parameter operation: A closure that takes `Configs` and returns a generic type `T`.
	/// - Rethrows: Rethrows any errors encountered within the closure.
	/// - Returns: The result of the closure of type `T`.
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
			configs.logger.error("Request creation failed with error: `\(error.humanReadable)`")
			throw error
		}
	}

	/// Provides a default value for a given configuration, which can differ between live, test, and preview environments.
	/// - Parameters:
	///   - live: An autoclosure returning the value for the live environment.
	///   - test: An optional autoclosure returning the value for the test environment.
	///   - preview: An optional autoclosure returning the value for the preview environment.
	/// - Returns: The appropriate value depending on the current environment.
	public func defaultFor<Value>(
		live: @autoclosure () -> Value,
		test: @autoclosure () -> Value? = nil,
		preview: @autoclosure () -> Value? = nil
	) -> Value {
		#if DEBUG
		if _isPreview {
			return preview() ?? test() ?? live()
		} else if _XCTIsTesting {
			return test() ?? preview() ?? live()
		} else {
			return live()
		}
		#else
		return live()
		#endif
	}
}

private let _XCTIsTesting: Bool = ProcessInfo.processInfo.environment.keys.contains("XCTestBundlePath")
private let _isPreview: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

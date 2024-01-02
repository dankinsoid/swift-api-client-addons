import Foundation
import MultipartFormDataKit
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	/// Appends path components to the URL of the request.
	/// - Parameter components: A variadic list of components that conform to `CustomStringConvertible`.
	/// - Returns: An instance of `NetworkClient` with updated path.
	subscript(_ components: any CustomStringConvertible...) -> NetworkClient {
		path(components)
	}

	/// Appends path components to the URL of the request.
	/// - Parameter components: A variadic list of components that conform to `CustomStringConvertible`.
	/// - Returns: An instance of `NetworkClient` with updated path.
	func path(_ components: any CustomStringConvertible...) -> NetworkClient {
		path(components)
	}

	/// Appends an array of path components to the URL of the request.
	/// - Parameter components: An array of components that conform to `CustomStringConvertible`.
	/// - Returns: An instance of `NetworkClient` with updated path.
	func path(_ components: [any CustomStringConvertible]) -> NetworkClient {
		modifyRequest {
			for component in components {
				$0.url?.appendPathComponent(component.description)
			}
		}
	}
}

public extension NetworkClient {

	/// Sets the HTTP method for the request.
	/// - Parameter method: The `HTTPMethod` to set for the request.
	/// - Returns: An instance of `NetworkClient` with the specified HTTP method.
	func method(_ method: HTTPMethod) -> NetworkClient {
		modifyRequest {
			$0.method = method
		}
	}
}

public extension NetworkClient {

	/// Adds or updates HTTP headers for the request.
	/// - Parameters:
	///   - headers: A variadic list of `HTTPHeader` to set or update.
	///   - update: A Boolean to determine whether to update existing headers. Default is `false`.
	/// - Returns: An instance of `NetworkClient` with modified headers.
	func headers(_ headers: HTTPHeader..., update: Bool = false) -> NetworkClient {
		modifyRequest {
			for header in headers {
				if update {
					$0.setValue(header.value, forHTTPHeaderField: header.name.rawValue)
				} else {
					$0.addValue(header.value, forHTTPHeaderField: header.name.rawValue)
				}
			}
		}
	}

	/// Removes a specific HTTP header from the request.
	/// - Parameter field: The key of the header to remove.
	/// - Returns: An instance of `NetworkClient` with the specified header removed.
	func removeHeader(_ field: HTTPHeader.Key) -> NetworkClient {
		modifyRequest {
			$0.setValue(nil, forHTTPHeaderField: field.rawValue)
		}
	}

	/// Adds or updates a specific HTTP header for the request.
	/// - Parameters:
	///   - field: The key of the header to add or update.
	///   - value: The value for the header.
	///   - update: A Boolean to determine whether to update the header if it exists. Default is `false`.
	/// - Returns: An instance of `NetworkClient` with modified header.
	func header(_ field: HTTPHeader.Key, _ value: String, update: Bool = false) -> NetworkClient {
		headers(HTTPHeader(field, value), update: update)
	}
}

public extension NetworkClient {

	/// Sets the request body with a specified value and serializer.
	/// - Parameters:
	///   - value: The value to be serialized and set as the body.
	///   - serializer: The `ContentSerializer` used to serialize the body value.
	/// - Returns: An instance of `NetworkClient` with the serialized body.
	func body<T>(_ value: T, as serializer: ContentSerializer<T>) -> NetworkClient {
		modifyRequest { req, configs in
			let (data, contentType) = try serializer.serialize(value, configs)
			req.httpBodyStream = nil
			req.httpBody = data
			req.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeader.Key.contentType.rawValue)
		}
	}

	/// Sets the request body with an `Encodable` value.
	/// - Parameter value: The `Encodable` value to set as the body.
	/// - Returns: An instance of `NetworkClient` with the serialized body.
	func body(_ value: some Encodable) -> NetworkClient {
		body(value, as: .encodable)
	}

	/// Sets the request body with a JSON object.
	/// - Parameter json: The JSON object to set as the body.
	/// - Returns: An instance of `NetworkClient` with the serialized body.
	func body(_ json: JSON) -> NetworkClient {
		body(json, as: .json)
	}

	/// Sets the request body with a closure that provides `Data`.
	/// - Parameter data: A closure returning the `Data` to be set as the body.
	/// - Returns: An instance of `NetworkClient` with the specified body.
	func body(_ data: @escaping @autoclosure () throws -> Data) -> NetworkClient {
		body { _ in try data() }
	}

	/// Sets the request body with a closure that dynamically provides `Data` based on configurations.
	/// - Parameter data: A closure taking `Configs` and returning `Data` to be set as the body.
	/// - Returns: An instance of `NetworkClient` with the specified body.
	func body(_ data: @escaping (Configs) throws -> Data) -> NetworkClient {
		modifyRequest { req, configs in
			req.httpBodyStream = nil
			req.httpBody = try data(configs)
		}
	}
}

public extension NetworkClient {

	/// Adds URL query parameters using an `Encodable` object.
	/// - Parameter items: An `Encodable` object to be used as query parameters.
	/// - Returns: An instance of `NetworkClient` with set query parameters.
	func query(_ items: any Encodable) -> NetworkClient {
		query {
			try $0.queryEncoder.encode(items)
		}
	}

	/// Adds URL query parameters using a closure providing an array of `URLQueryItem`.
	/// - Parameter items: A closure returning an array of `URLQueryItem` to be set as query parameters.
	/// - Returns: An instance of `NetworkClient` with set query parameters.
	func query(_ items: @escaping @autoclosure () throws -> [URLQueryItem]) -> NetworkClient {
		query { _ in
			try items()
		}
	}

	/// Adds URL query parameters with a closure that dynamically provides an array of `URLQueryItem` based on configurations.
	/// - Parameter items: A closure taking `Configs` and returning an array of `URLQueryItem`.
	/// - Returns: An instance of `NetworkClient` with set query parameters.
	func query(_ items: @escaping (Configs) throws -> [URLQueryItem]) -> NetworkClient {
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

	/// Adds URL query parameters using a dictionary of JSON objects.
	/// - Parameter json: A dictionary of `String: JSON` pairs to be used as query parameters.
	/// - Returns: An instance of `NetworkClient` with set query parameters.
	func query(_ parameters: [String: Encodable?]) -> NetworkClient {
		query {
			try $0.queryEncoder
				.encode(parameters.compactMapValues { $0.map { AnyEncodable($0) }})
				.sorted(by: { $0.name < $1.name })
		}
	}

	/// Adds a single URL query parameter.
	/// - Parameters:
	///   - field: The field name of the query parameter.
	///   - value: The value of the query parameter.
	/// - Returns: An instance of `NetworkClient` with the specified query parameter.
	func query(_ field: String, _ value: String?) -> NetworkClient {
		query(value.map { [URLQueryItem(name: field, value: $0)] } ?? [])
	}

	/// Adds a single URL query parameter.
	/// - Parameters:
	///   - field: The field name of the query parameter.
	///   - value: The value of the query parameter, conforming to `RawRepresentable`.
	/// - Returns: An instance of `NetworkClient` with the specified query parameter.
	func query<R: RawRepresentable>(_ field: String, _ value: R?) -> NetworkClient where R.RawValue == String {
		query(field, value?.rawValue)
	}

	/// Adds a single URL query parameter.
	/// - Parameters:
	///   - field: The field name of the query parameter.
	///   - value: The value of the query parameter, conforming to `Encodable`.
	/// - Returns: An instance of `NetworkClient` with the specified query parameter.
	@_disfavoredOverload
	func query(_ field: String, _ value: Encodable?) -> NetworkClient {
		query([field: value])
	}
}

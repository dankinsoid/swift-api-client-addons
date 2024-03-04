import Foundation
import MultipartFormDataKit
import SwiftJSON
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	/// Sets the request body with a JSON object.
	/// - Parameter json: The JSON object to set as the body.
	/// - Returns: An instance of `NetworkClient` with the serialized body.
	func body(_ json: JSON) -> NetworkClient {
		body(json, as: .json)
	}
}

public extension NetworkClient {

	/// Sets the request body stream with a JSON object.
	/// - Parameter json: The JSON object to set as the body stream.
	/// - Returns: An instance of `NetworkClient` with the serialized body stream.
	func bodyStream(_ json: JSON) -> NetworkClient {
		bodyStream(json, as: .json)
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
	///   - value: The value of the query parameter, conforming to `Encodable`.
	/// - Returns: An instance of `NetworkClient` with the specified query parameter.
	@_disfavoredOverload
	func query(_ field: String, _ value: Encodable?) -> NetworkClient {
		query([field: value])
	}
}

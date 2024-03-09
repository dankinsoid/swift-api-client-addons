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

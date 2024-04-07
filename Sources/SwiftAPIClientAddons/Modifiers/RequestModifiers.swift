import Foundation
import SwiftJSON
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension APIClient {

	/// Sets the request body with a JSON object.
	/// - Parameter json: The JSON object to set as the body.
	/// - Returns: An instance of `APIClient` with the serialized body.
	func body(_ json: JSON) -> APIClient {
		body(json, as: .json)
	}
}

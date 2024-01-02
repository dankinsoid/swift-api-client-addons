import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A struct for validating `URLRequest` instances.
public struct RequestValidator {

	/// A closure that validates a `URLRequest`.
	/// - Throws: An error if validation fails.
	public var validate: (_ request: URLRequest, NetworkClient.Configs) throws -> Void

	/// Initializes a new `RequestValidator` with a custom validation closure.
	/// - Parameter validate: A closure that takes a `URLRequest` and throws an error if validation fails.
	public init(validate: @escaping (_ request: URLRequest, NetworkClient.Configs) throws -> Void) {
		self.validate = validate
	}
}

public extension RequestValidator {

	/// A default validator that always considers the request as successful, regardless of its content.
	static var alwaysSuccess: Self {
		RequestValidator { _, _ in }
	}
}

public extension NetworkClient.Configs {

	/// The request validator used for validating `URLRequest` instances.
	/// Gets the currently set `RequestValidator`, or `.alwaysSuccess` if not set.
	/// Sets a new `RequestValidator`.
	var requestValidator: RequestValidator {
		get { self[\.requestValidator] ?? .alwaysSuccess }
		set { self[\.requestValidator] = newValue }
	}
}

public extension NetworkClient {

	/// Sets a custom request validator for the network client.
	/// - Parameter validator: The `RequestValidator` to be used for validating `URLRequest` instances.
	/// - Returns: An instance of `NetworkClient` configured with the specified request validator.
	func requestValidator(_ validator: RequestValidator) -> NetworkClient {
		configs {
			let old = $0.requestValidator.validate
			$0.requestValidator = RequestValidator {
				try old($0, $1)
				try validator.validate($0, $1)
			}
		}
	}
}

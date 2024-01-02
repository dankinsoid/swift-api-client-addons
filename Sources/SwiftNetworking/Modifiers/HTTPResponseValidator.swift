import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct HTTPResponseValidator {

	public var validate: (HTTPURLResponse, Data) throws -> Void

	public init(_ validate: @escaping (HTTPURLResponse, Data) throws -> Void) {
		self.validate = validate
	}
}

public extension HTTPResponseValidator {

	static var statusCode: Self {
		statusCode(200 ... 299)
	}

	static func statusCode(_ codes: ClosedRange<Int>) -> Self {
		HTTPResponseValidator { response, _ in
			guard codes.contains(response.statusCode) else {
				throw Errors.invalidStatusCode(response.statusCode)
			}
		}
	}
}

public extension HTTPResponseValidator {

	static var alwaysSuccess: Self {
		HTTPResponseValidator { _, _ in }
	}
}

public extension NetworkClient.Configs {

	var httpResponseValidator: HTTPResponseValidator {
		get { self[\.httpResponseValidator] ?? .alwaysSuccess }
		set { self[\.httpResponseValidator] = newValue }
	}
}

public extension NetworkClient {

	func httpResponseValidator(_ validator: HTTPResponseValidator) -> NetworkClient {
		configs {
			let oldValidator = $0.httpResponseValidator.validate
			$0.httpResponseValidator = HTTPResponseValidator {
				try oldValidator($0, $1)
				try validator.validate($0, $1)
			}
		}
	}
}

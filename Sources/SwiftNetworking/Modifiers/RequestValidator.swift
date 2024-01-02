import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct RequestValidator {

	public var validate: (_ request: URLRequest) throws -> Void

	public init(validate: @escaping (_ request: URLRequest) throws -> Void) {
		self.validate = validate
	}
}

public extension RequestValidator {

	static var alwaysSuccess: Self {
		RequestValidator { _ in }
	}
}

public extension NetworkClient.Configs {

	var requestValidator: RequestValidator {
		get { self[\.requestValidator] ?? .alwaysSuccess }
		set { self[\.requestValidator] = newValue }
	}
}

public extension NetworkClient {

	func requestValidator(_ validator: RequestValidator) -> NetworkClient {
		configs {
			let old = $0.requestValidator.validate
			$0.requestValidator = RequestValidator {
				try old($0)
				try validator.validate($0)
			}
		}
	}
}

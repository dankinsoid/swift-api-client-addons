import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol RequestValidator {
    
    func validate(_ response: URLRequest) throws
}

public struct AlwaysSuccessRequestValidator: RequestValidator {
    
    public init() {}
    
    public func validate(_ response: URLRequest) throws {}
}

extension RequestValidator where Self == AlwaysSuccessRequestValidator {
    
    public static var alwaysSuccess: Self {
        AlwaysSuccessRequestValidator()
    }
}

public extension NetworkClient.Configs {
    
    var requestValidator: RequestValidator {
        get { self[\.requestValidator] ?? .alwaysSuccess }
        set { self[\.requestValidator] = newValue }
    }
}

public extension NetworkClient {
    
    func requestValidator(_ validator: some RequestValidator) -> NetworkClient {
        configs {
            $0.requestValidator = ChainRequestValidator(validator: ($0.requestValidator, validator))
        }
    }
}

private struct ChainRequestValidator: RequestValidator {
    
    let validator: (RequestValidator, RequestValidator)
    
    func validate(_ request: URLRequest) throws {
        try validator.0.validate(request)
        try validator.1.validate(request)
    }
}

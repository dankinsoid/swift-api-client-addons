import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct ResponseValidator {
    
    public var validate: (HTTPURLResponse, Data) throws -> Void
    
    public init(_ validate: @escaping (HTTPURLResponse, Data) throws -> Void) {
        self.validate = validate
    }
}

extension ResponseValidator {
    
    public static var statusCode: Self {
        statusCode(200...299)
    }
    
    public static func statusCode(_ codes: ClosedRange<Int>) -> Self {
        ResponseValidator { response, _ in
            guard codes.contains(response.statusCode) else {
                throw Errors.invalidStatusCode(response.statusCode)
            }
        }
    }
}

extension ResponseValidator {
    
    public static var alwaysSuccess: Self {
        ResponseValidator { _, _ in }
    }
}

public extension NetworkClient.Configs {
    
    var responseValidator: ResponseValidator {
        get { self[\.responseValidator] ?? .alwaysSuccess }
        set { self[\.responseValidator] = newValue }
    }
}

public extension NetworkClient {
    
    func responseValidator(_ validator: ResponseValidator) -> NetworkClient {
        configs {
            let oldValidator = $0.responseValidator.validate
            $0.responseValidator = ResponseValidator {
                try oldValidator($0, $1)
                try validator.validate($0, $1)
            }
        }
    }
}

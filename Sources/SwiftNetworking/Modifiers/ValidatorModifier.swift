import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol HTTPResponseValidator {

    func validate(response: HTTPURLResponse, body: Data) throws
}

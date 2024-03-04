import Foundation

public struct AnyEncodable: Encodable {
    
    public var base: Encodable
    
    public init(_ base: Encodable) {
        self.base = base
    }
    
    public func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
    }
}

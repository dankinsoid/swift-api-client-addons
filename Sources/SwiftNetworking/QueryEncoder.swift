import Foundation
import VDCodable
import SimpleCoders

public protocol QueryEncoder: CodableEncoder where Output == [URLQueryItem] {
}

extension URLQueryEncoder: QueryEncoder {}

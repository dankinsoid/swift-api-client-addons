import Foundation
import SimpleCoders
import VDCodable

public protocol QueryEncoder: CodableEncoder where Output == [URLQueryItem] {}

extension URLQueryEncoder: QueryEncoder {}

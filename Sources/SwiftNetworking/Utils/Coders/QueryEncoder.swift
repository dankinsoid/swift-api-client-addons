import Foundation
import SimpleCoders
import VDCodable

/// Protocol defining an encoder that serializes data into a query parameters array.
public protocol QueryEncoder: CodableEncoder where Output == [URLQueryItem] {}

extension URLQueryEncoder: QueryEncoder {}

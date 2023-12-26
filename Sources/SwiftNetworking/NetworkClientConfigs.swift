import Foundation
import Logging

public extension NetworkClient {
    
    struct Configs {

        private var values: [PartialKeyPath<NetworkClient.Configs>: Any] = [:]

        public init() {}

        public subscript<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>) -> T? {
            get { values[keyPath] as? T }
            set { values[keyPath] = newValue }
        }
        
        public func with<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>, _ value: T) -> NetworkClient.Configs {
            var result = self
            result[keyPath: keyPath] = value
            return result
        }
    }
}

import VDCodable

extension NetworkClient.Configs {
    
    public var bodyEncoder: any ContentEncoder {
        get { self[\.bodyEncoder] ?? JSONEncoder() }
        set { self[\.bodyEncoder] = newValue }
    }
    
    public var bodyDecoder: any DataDecoder {
        get { self[\.bodyDecoder] ?? JSONDecoder() }
        set { self[\.bodyDecoder] = newValue }
    }
    
    public var queryEncoder: any QueryEncoder {
        get { self[\.queryEncoder] ?? URLQueryEncoder() }
        set { self[\.queryEncoder] = newValue }
    }
}

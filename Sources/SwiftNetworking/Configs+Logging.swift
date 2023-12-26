import Foundation
import Logging

public extension NetworkClient.Configs {
    
    var logLevel: Logger.Level {
        get { self[\.logLevel] ?? .critical }
        set { self[\.logLevel] = newValue }
    }
    
    var logger: Logger {
        var result = _logger
        result.logLevel = logLevel
        return result
    }
}

private let _logger = Logger(label: "swift-networking")

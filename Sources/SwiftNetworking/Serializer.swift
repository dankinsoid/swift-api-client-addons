import Foundation
import VDCodable

public struct Serializer<Response, T> {

    public var serialize: (_ response: Response, _ configs: NetworkClient.Configs) throws -> T

    public init(_ serialize: @escaping (Response, NetworkClient.Configs) throws -> T) {
        self.serialize = { response, configs in
            do {
                return try serialize(response, configs)
            } catch {
                configs.logger.error("Response decoding failed with error: `\(error.localizedDescription)`")
                throw error
            }
        }
    }
}

extension Serializer where Response == Data, T == Data {
    
    public static var data: Self {
        Self { data, _ in data }
    }
}

extension Serializer where Response == Data, T == Void {
    
    public static var void: Self {
        Self { _, _ in }
    }
}

extension Serializer where Response == Data, T == JSON {
    
    public static var json: Self {
        Self { data, _ in try JSON(from: data) }
    }
}

extension Serializer where Response == Data, T: Decodable {

    public static func decodable(_ type: T.Type) -> Self {
        Self { data, configs in
            try configs.bodyDecoder.decode(T.self, from: data)
        }
    }

    public static var decodable: Self {
        .decodable(T.self)
    }
}

import Foundation
import VDCodable
import MultipartFormDataKit

public struct ContentSerializer<T> {

    public var serialize: (_ value: T, _ configs: NetworkClient.Configs) throws -> (Data, ContentType)

    public init(
        _ serialize: @escaping (T, NetworkClient.Configs) throws -> (Data, ContentType)
    ) {
        self.serialize = { value, configs in
            do {
                return try serialize(value, configs)
            } catch {
                configs.logger.error("Response decoding failed with error: `\(error)`")
                throw error
            }
        }
    }
}

public extension ContentSerializer where T: Encodable {

    static var encodable: Self {
        .encodable(T.self)
    }

    static func encodable(_ type: T.Type) -> Self {
        ContentSerializer { value, configs in
            let encoder = configs.bodyEncoder
            return try (encoder.encode(value), encoder.contentType)
        }
    }
}

extension ContentSerializer where T == JSON {

    public static var json: Self {
        Self { json, _ in (json.data, .application(.json)) }
    }
}

extension ContentSerializer where T: Collection, T.Element == MultipartFormData.PartParam {
    
    public static var multipartFormData: Self {
        .multipartFormData(boundary: defaultBoundary)
    }
    
    public static func multipartFormData(boundary: String) -> Self {
        Self { partParams, _ in
            try (
                MultipartFormData.Builder.build(
                    with: Array(partParams),
                    willSeparateBy: boundary
                ).body,
                .multipart(.formData)
            )
        }
    }
}

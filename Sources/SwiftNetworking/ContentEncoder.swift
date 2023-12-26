import VDCodable
import SimpleCoders
import Foundation
import MultipartFormDataKit

public protocol ContentEncoder: CodableEncoder where Output == Data {
    
    static var contentType: ContentType { get }
}

extension JSONEncoder: ContentEncoder {
    
    public static var contentType: ContentType {
        .application(.json)
    }
}

extension VDJSONEncoder: ContentEncoder {
    
    public static var contentType: ContentType {
        .application(.json)
    }
}

extension ContentEncoder where Self == JSONEncoder {
    
    static var json: Self { .json() }
    
    static func json(
        outputFormatting: JSONEncoder.OutputFormatting = .sortedKeys,
        dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw
    ) -> Self {
        var encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.dataEncodingStrategy = dataEncodingStrategy
        encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        return encoder
    }
}

extension ContentEncoder where Self == FormURLEncoder {
    
    static var formURL: Self { .formURL() }
    
    static func formURL(
        dateEncodingStrategy: any DateEncodingStrategy = SecondsSince1970CodingStrategy(),
        keyEncodingStrategy: any KeyEncodingStrategy = UseDeafultKeyCodingStrategy(),
        arrayEncodingStrategy: URLQueryEncoder.ArrayEncodingStrategy = .commaSeparator,
        nestedEncodingStrategy: URLQueryEncoder.DictionaryEncodingStrategy = .point,
        trimmingSquareBrackets: Bool = true
    ) -> Self {
        FormURLEncoder(
            dateEncodingStrategy: dateEncodingStrategy,
            keyEncodingStrategy: keyEncodingStrategy,
            arrayEncodingStrategy: arrayEncodingStrategy,
            nestedEncodingStrategy: nestedEncodingStrategy,
            trimmingSquareBrackets: trimmingSquareBrackets
        )
    }
}

public struct FormURLEncoder: ContentEncoder {
    
    private var urlEncoder: URLQueryEncoder
    
    public init(
        dateEncodingStrategy: any DateEncodingStrategy = SecondsSince1970CodingStrategy(),
        keyEncodingStrategy: any KeyEncodingStrategy = UseDeafultKeyCodingStrategy(),
        arrayEncodingStrategy: URLQueryEncoder.ArrayEncodingStrategy = .commaSeparator,
        nestedEncodingStrategy: URLQueryEncoder.DictionaryEncodingStrategy = .point,
        trimmingSquareBrackets: Bool = true
    ) {
        urlEncoder = URLQueryEncoder(
            dateEncodingStrategy: dateEncodingStrategy,
            keyEncodingStrategy: keyEncodingStrategy,
            arrayEncodingStrategy: arrayEncodingStrategy,
            nestedEncodingStrategy: nestedEncodingStrategy
        )
        urlEncoder.trimmingSquareBrackets = trimmingSquareBrackets
    }
    
    public static var contentType: ContentType {
        .application(.urlEncoded)
    }
    
    public func encode(_ value: some Encodable) throws -> Data {
        guard let data = try urlEncoder.encodePath(value).data(using: .utf8) else { throw Errors.unknown }
        return data
    }
}

public struct MultipartFormDataEncoder: ContentEncoder {
    
    public static var contentType: ContentType {
        .multipart(.formData)
    }
    
    public var boundary = "boundary." + RandomBoundaryGenerator.generate()
    
    public func encode(_ value: some Encodable) throws -> Data {
        let params = try URLQueryEncoder().encode(value)
        return try MultipartFormData.Builder.build(
            with: params.map {
                (
                    name: $0.name,
                    filename: nil,
                    mimeType: nil,
                    data: $0.value?.data(using: .utf8) ?? Data()
                )
            },
            willSeparateBy: boundary
        ).body
    }
}

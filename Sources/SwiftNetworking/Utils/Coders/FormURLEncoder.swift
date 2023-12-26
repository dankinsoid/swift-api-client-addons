import Foundation
import SimpleCoders
import VDCodable

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

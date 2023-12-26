import Foundation
import SimpleCoders
import VDCodable

public extension ContentEncoder where Self == JSONEncoder {

	static var json: Self { .json() }

	static func json(
		outputFormatting: JSONEncoder.OutputFormatting = .sortedKeys,
		dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData,
		dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate,
		keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
		nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .throw
	) -> Self {
		let encoder = JSONEncoder()
		encoder.outputFormatting = outputFormatting
		encoder.dateEncodingStrategy = dateEncodingStrategy
		encoder.keyEncodingStrategy = keyEncodingStrategy
		encoder.dataEncodingStrategy = dataEncodingStrategy
		encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
		return encoder
	}
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

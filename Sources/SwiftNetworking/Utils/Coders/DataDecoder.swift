import Foundation
import SimpleCoders
import VDCodable

public protocol DataDecoder: CodableDecoder where Input == Data {}

extension JSONDecoder: DataDecoder {}

extension VDJSONDecoder: DataDecoder {}

extension PropertyListDecoder: DataDecoder {}

public extension DataDecoder where Self == JSONDecoder {

	static var json: Self { .json() }

	static func json(
		dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
		dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
		nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
		keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
		allowsJSON5: Bool = false,
		assumesTopLevelDictionary: Bool = false
	) -> Self {
		let decoder = JSONDecoder()
		decoder.dataDecodingStrategy = dataDecodingStrategy
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
		if #available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
			decoder.allowsJSON5 = allowsJSON5
			decoder.assumesTopLevelDictionary = assumesTopLevelDictionary
		}
		return decoder
	}
}

import Foundation
import SimpleCoders
import VDCodable

/// A protocol defining a decoder for deserializing `Data` into decodable types.
public protocol DataDecoder: CodableDecoder where Input == Data {}

extension JSONDecoder: DataDecoder {}

extension VDJSONDecoder: DataDecoder {}

extension PropertyListDecoder: DataDecoder {}

public extension DataDecoder where Self == JSONDecoder {

	/// A static property to get a `JSONDecoder` instance with default settings.
	static var json: Self { .json() }

	/// Creates and returns a `JSONDecoder` with customizable decoding strategies.
	/// - Parameters:
	///   - dateDecodingStrategy: Strategy for decoding date values. Default is `.deferredToDate`.
	///   - dataDecodingStrategy: Strategy for decoding data values. Default is `.deferredToData`.
	///   - nonConformingFloatDecodingStrategy: Strategy for decoding non-conforming float values. Default is `.throw`.
	///   - keyDecodingStrategy: Strategy for decoding keys. Default is `.useDefaultKeys`.
	///   - allowsJSON5: A flag determining if JSON5 is allowed. Default is `false`. Available since macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0.
	///   - assumesTopLevelDictionary: A flag determining if a top-level dictionary is assumed. Default is `false`. Available since macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0.
	/// - Returns: An instance of `JSONDecoder` configured with the specified strategies.
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

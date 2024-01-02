import Foundation
import MultipartFormDataKit
import SimpleCoders
import VDCodable

/// A protocol defining an encoder that serializes data into a specific content type.
public protocol ContentEncoder: CodableEncoder where Output == Data {

	/// The `ContentType` associated with the serialized data.
	/// This property specifies the MIME type that the encoder outputs.
	var contentType: ContentType { get }
}

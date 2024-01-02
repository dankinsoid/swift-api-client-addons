import Foundation
import MultipartFormDataKit
import SimpleCoders
import VDCodable

public protocol ContentEncoder: CodableEncoder where Output == Data {

	var contentType: ContentType { get }
}

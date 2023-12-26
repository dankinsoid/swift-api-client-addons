import Foundation
import MultipartFormDataKit
import SimpleCoders
import VDCodable

public protocol ContentEncoder: CodableEncoder where Output == Data {

	static var contentType: ContentType { get }
}

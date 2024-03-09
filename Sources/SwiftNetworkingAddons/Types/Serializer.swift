import Foundation
import SwiftJSON

public extension Serializer where Response == Data, T == JSON {

	/// A static property to get a `Serializer` that converts response `Data` into `JSON`.
	static var json: Self {
		Self { data, _ in try JSON(from: data) }
	}
}

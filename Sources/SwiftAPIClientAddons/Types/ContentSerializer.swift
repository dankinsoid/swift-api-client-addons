import Foundation
import SwiftJSON

public extension ContentSerializer where T == JSON {

	/// A static property to get a `ContentSerializer` for JSON.
	static var json: Self {
		Self { json, _ in (json.data, .application(.json)) }
	}
}

import Foundation
import MultipartFormDataKit
import SwiftJSON

public extension ContentSerializer where T == JSON {

	/// A static property to get a `ContentSerializer` for JSON.
	static var json: Self {
		Self { json, _ in (json.data, .application(.json)) }
	}
}

public extension ContentSerializer where T: Collection, T.Element == MultipartFormData.PartParam {

	/// A static property to get a `ContentSerializer` for multipart/form-data with a default boundary.
	static var multipartFormData: Self {
		.multipartFormData(boundary: defaultBoundary)
	}

	/// Creates a `ContentSerializer` for multipart/form-data with a custom boundary.
	/// - Parameter boundary: The boundary string to use in the multipart/form-data.
	/// - Returns: A `ContentSerializer` that constructs multipart/form-data using the provided boundary.
	static func multipartFormData(boundary: String) -> Self {
		Self { partParams, _ in
			try (
				MultipartFormData.Builder.build(
					with: Array(partParams),
					willSeparateBy: boundary
				).body,
				.multipart(.formData)
			)
		}
	}
}

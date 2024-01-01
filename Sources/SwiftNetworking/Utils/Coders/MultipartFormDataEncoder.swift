import Foundation
import MultipartFormDataKit
import VDCodable

public extension ContentEncoder where Self == MultipartFormDataEncoder {

	static var multipartFormData: Self {
		multipartFormData()
	}

	static func multipartFormData(boundary: String? = nil) -> Self {
		MultipartFormDataEncoder(boundary: boundary ?? defaultBoundary)
	}
}

public struct MultipartFormDataEncoder: ContentEncoder {

	public var contentType: ContentType {
		.multipart(.formData)
	}

	public var boundary = defaultBoundary

	public func encode(_ value: some Encodable) throws -> Data {
		let params = try URLQueryEncoder().encode(value)
		return try MultipartFormData.Builder.build(
			with: params.map {
				(
					name: $0.name,
					filename: nil,
					mimeType: nil,
					data: $0.value?.data(using: .utf8) ?? Data()
				)
			},
			willSeparateBy: boundary
		).body
	}
}

let defaultBoundary = "boundary." + RandomBoundaryGenerator.generate()

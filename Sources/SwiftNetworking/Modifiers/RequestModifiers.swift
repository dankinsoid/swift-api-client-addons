import Foundation
import MultipartFormDataKit
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	func path(_ components: any CustomStringConvertible...) -> NetworkClient {
		path(components)
	}

	func path(_ components: [any CustomStringConvertible]) -> NetworkClient {
		modifyRequest {
			for component in components {
				$0.url?.appendPathComponent(component.description)
			}
		}
	}
}

public extension NetworkClient {

	func method(_ method: HTTPMethod) -> NetworkClient {
		modifyRequest {
			$0.httpMethod = method.rawValue
		}
	}
}

public extension NetworkClient {

	func header(_ field: HTTPHeaderKey, set value: String) -> NetworkClient {
		modifyRequest {
			$0.setValue(value, forHTTPHeaderField: field.rawValue)
		}
	}

	func header(_ field: HTTPHeaderKey, add value: String) -> NetworkClient {
		modifyRequest {
			$0.addValue(value, forHTTPHeaderField: field.rawValue)
		}
	}

	func headers(set headers: [HTTPHeaderKey: String]) -> NetworkClient {
		modifyRequest {
			for (field, value) in headers {
				$0.setValue(value, forHTTPHeaderField: field.rawValue)
			}
		}
	}

	func headers(add headers: [HTTPHeaderKey: String]) -> NetworkClient {
		modifyRequest {
			for (field, value) in headers {
				$0.addValue(value, forHTTPHeaderField: field.rawValue)
			}
		}
	}
}

public extension NetworkClient {

	func body(_ value: any Encodable) -> NetworkClient {
		body {
			try $0.bodyEncoder.encode(value)
		}
	}

	func body(_ data: @escaping @autoclosure () throws -> Data) -> NetworkClient {
		body { _ in try data() }
	}

	func body(_ data: @escaping (Configs) throws -> Data) -> NetworkClient {
		modifyRequest { req, configs in
			req.httpBodyStream = nil
			req.httpBody = try data(configs)
		}
	}

	func body(
		multiparts partParams: [MultipartFormData.PartParam],
		boundary: String? = nil
	) -> NetworkClient {
		try body(
			MultipartFormData.Builder.build(
				with: partParams,
				willSeparateBy: boundary ?? defaultBoundary
			).body
		)
		.contentType(.multipart(.formData))
	}

	func body(_ json: JSON) -> NetworkClient {
		body(json.data)
			.contentType(.application(.json))
	}
}

public extension NetworkClient {

	func query(_ items: any Encodable) -> NetworkClient {
		query {
			try $0.queryEncoder.encode(items)
		}
	}

	func query(_ items: @escaping @autoclosure () throws -> [URLQueryItem]) -> NetworkClient {
		query { _ in
			try items()
		}
	}

	func query(_ items: @escaping (Configs) throws -> [URLQueryItem]) -> NetworkClient {
		modifyRequest { req, configs in
			if #available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
				try req.url?.append(queryItems: items(configs))
			} else if
				let url = req.url,
				var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
			{
				if components.queryItems == nil {
					components.queryItems = []
				}
				try components.queryItems?.append(contentsOf: items(configs))
				req.url = components.url ?? url
			}
		}
	}

	func query(_ json: [String: JSON]) -> NetworkClient {
		query(
			json.sorted(by: { $0.key < $1.key })
				.map { URLQueryItem(name: $0.key, value: $0.value.description) }
		)
	}

	func query(_ field: String, _ value: CustomStringConvertible) -> NetworkClient {
		query([field: .string(value.description)])
	}
}

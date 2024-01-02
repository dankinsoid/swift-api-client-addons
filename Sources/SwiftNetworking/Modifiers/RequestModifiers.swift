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
			$0.method = method
		}
	}
}

public extension NetworkClient {

	func headers(_ headers: HTTPHeader..., update: Bool = false) -> NetworkClient {
		modifyRequest {
			for header in headers {
				if update {
					$0.setValue(header.value, forHTTPHeaderField: header.name.rawValue)
				} else {
					$0.addValue(header.value, forHTTPHeaderField: header.name.rawValue)
				}
			}
		}
	}

	func removeHeader(_ field: HTTPHeader.Key) -> NetworkClient {
		modifyRequest {
			$0.setValue(nil, forHTTPHeaderField: field.rawValue)
		}
	}

	func header(_ field: HTTPHeader.Key, _ value: String, update: Bool = false) -> NetworkClient {
		headers(HTTPHeader(field, value), update: update)
	}
}

public extension NetworkClient {

	func body<T>(_ value: T, as serializer: ContentSerializer<T>) -> NetworkClient {
		modifyRequest { req, configs in
			let (data, contentType) = try serializer.serialize(value, configs)
			req.httpBodyStream = nil
			req.httpBody = data
			req.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeader.Key.contentType.rawValue)
		}
	}

	func body(_ value: some Encodable) -> NetworkClient {
		body(value, as: .encodable)
	}

	func body(_ json: JSON) -> NetworkClient {
		body(json, as: .json)
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
		query([URLQueryItem(name: field, value: value.description)])
	}
}

import Foundation
import VDCodable

public struct Serializer<Response, T> {

	public var serialize: (_ response: Response, _ configs: NetworkClient.Configs) throws -> T

	public init(_ serialize: @escaping (Response, NetworkClient.Configs) throws -> T) {
		self.serialize = { response, configs in
			do {
				return try serialize(response, configs)
			} catch {
				configs.logger.error("Response decoding failed with error: `\(error.humanReadable)`")
				throw error
			}
		}
	}
}

public extension Serializer where Response == Data, T == Data {

	static var data: Self {
		Self { data, _ in data }
	}
}

public extension Serializer where Response == Data, T == Void {

	static var void: Self {
		Self { _, _ in }
	}
}

public extension Serializer where Response == Data, T == JSON {

	static var json: Self {
		Self { data, _ in try JSON(from: data) }
	}
}

public extension Serializer where Response == Data, T: Decodable {

	static func decodable(_: T.Type) -> Self {
		Self { data, configs in
			try configs.bodyDecoder.decode(T.self, from: data)
		}
	}

	static var decodable: Self {
		.decodable(T.self)
	}
}

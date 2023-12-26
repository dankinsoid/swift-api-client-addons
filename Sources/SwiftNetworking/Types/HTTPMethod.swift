import Foundation

public struct HTTPMethod: LosslessStringConvertible, RawRepresentable, Codable, Hashable, ExpressibleByStringLiteral {

	public let rawValue: String
	public var description: String { rawValue }

	public init(_ description: String) {
		rawValue = description.uppercased()
	}

	public init(rawValue: String) {
		self.init(rawValue)
	}

	public init(stringLiteral value: String) {
		self.init(value)
	}

	public init(from decoder: Decoder) throws {
		try self.init(String(from: decoder))
	}

	public func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}

	public static let get = HTTPMethod("GET")
	public static let put = HTTPMethod("PUT")
	public static let post = HTTPMethod("POST")
	public static let delete = HTTPMethod("DELETE")
	public static let options = HTTPMethod("OPTIONS")
	public static let head = HTTPMethod("HEAD")
	public static let patch = HTTPMethod("PATCH")
	public static let trace = HTTPMethod("TRACE")
}

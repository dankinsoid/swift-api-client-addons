import Foundation

public struct ContentType: Codable, Hashable, RawRepresentable, ExpressibleByStringLiteral, LosslessStringConvertible {

	public typealias RawValue = String
	public typealias StringLiteralType = String

	public var rawValue: String {
		get {
			(["\(type)/\(subtype)"] + parameters.map { "\($0.key)=\($0.value)" }.sorted())
				.joined(separator: ";")
		}
		set {
			self = ContentType(rawValue: newValue)
		}
	}

	public var description: String { rawValue }

	public var type: String
	public var subtype: String
	public var parameters: [String: String]

	public init(
		_ type: String,
		_ subtype: String,
		parameters: [String: String] = [:]
	) {
		self.type = type
		self.subtype = subtype
		self.parameters = parameters
	}

	public init(rawValue: String) {
		var type = ""
		var index = rawValue.startIndex
		while index < rawValue.endIndex, rawValue[index] != "/" {
			type.append(rawValue[index])
			index = rawValue.index(after: index)
		}
		if index < rawValue.endIndex {
			index = rawValue.index(after: index)
		}

		var subtype = ""
		while index < rawValue.endIndex, rawValue[index] != ";" {
			subtype.append(rawValue[index])
			index = rawValue.index(after: index)
		}

		var parameters: [String: String] = [:]
		while index < rawValue.endIndex {
			index = rawValue.index(after: index)
			guard index < rawValue.endIndex else { break }
			var key = ""
			while index < rawValue.endIndex, rawValue[index] != ";" {
				key.append(rawValue[index])
				index = rawValue.index(after: index)
			}
			var value = ""
			while index < rawValue.endIndex, rawValue[index] != ";" {
				value.append(rawValue[index])
				index = rawValue.index(after: index)
			}
			parameters[key] = value.trimmingCharacters(in: [" ", "\""])
		}
		self.init(
			type.isEmpty ? "*" : type,
			subtype.isEmpty ? "*" : subtype,
			parameters: parameters
		)
	}

	public init(stringLiteral value: String) {
		self.init(rawValue: value)
	}

	public init(_ stringValue: String) {
		self.init(rawValue: stringValue)
	}

	public init(from decoder: Decoder) throws {
		try self.init(rawValue: String(from: decoder))
	}

	public func encode(to encoder: Encoder) throws {
		try rawValue.encode(to: encoder)
	}
}

public extension ContentType {

	struct Application: RawRepresentable, ExpressibleByStringLiteral {
		public var rawValue: String

		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}

		public init(stringLiteral value: String) {
			self.init(rawValue: value)
		}

		public static let json: Application = "json"
		public static let schemaJson: Application = "schema+json"
		public static let schemaInstanceJson: Application = "schema-instance+json"
		public static let xml: Application = "xml"
		public static let octetStream: Application = "octet-stream"
		public static let urlEncoded: Application = "x-www-form-urlencoded"
	}

	static func application(_ subtype: Application) -> ContentType {
		ContentType("application", subtype.rawValue)
	}

	struct Text: RawRepresentable, ExpressibleByStringLiteral {
		public var rawValue: String

		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}

		public init(stringLiteral value: String) {
			self.init(rawValue: value)
		}

		public static let plain: Text = "plain"
		public static let html: Text = "html"
	}

	static func text(_ subtype: Text, charset: String? = nil) -> ContentType {
		ContentType(
			"text",
			subtype.rawValue,
			parameters: charset.map { ["charset": $0] } ?? [:]
		)
	}

	struct Multipart: RawRepresentable, ExpressibleByStringLiteral {

		public var rawValue: String

		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}

		public init(stringLiteral value: String) {
			self.init(rawValue: value)
		}

		public static let formData: Multipart = "form-data"
		public static let byteranges: Multipart = "byteranges"
	}

	static func multipart(_ subtype: Multipart) -> ContentType {
		ContentType("multipart", subtype.rawValue)
	}

	static let any = ContentType("*", "*")
}

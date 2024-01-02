import Foundation

public protocol ErrorDecoder {

	func decodeError(from data: Data) -> Error?
}

public struct NoneErrorDecoder: ErrorDecoder {

	public func decodeError(from data: Data) -> Error? {
		nil
	}
}

public extension ErrorDecoder where Self == NoneErrorDecoder {

	static var none: Self {
		NoneErrorDecoder()
	}
}

struct DecodableErrorDecoder<Failure: Decodable & Error>: ErrorDecoder {

	let dataDecoder: any DataDecoder

	func decodeError(from data: Data) -> Error? {
		try? dataDecoder.decode(Failure.self, from: data)
	}
}

import Foundation

public extension NetworkClient.Configs {

	var errorDecoder: ErrorDecoder {
		get { self[\.errorDecoder] ?? .none }
		set { self[\.errorDecoder] = newValue }
	}
}

public extension NetworkClient {

	func errorDecoder(_ decoder: some ErrorDecoder) -> NetworkClient {
		configs(\.errorDecoder, decoder)
	}

	func decodableError<Failure: Decodable & Error>(
		_ type: Failure.Type,
		decoder: (any DataDecoder)? = nil
	) -> NetworkClient {
		configs {
			$0.errorDecoder = DecodableErrorDecoder<Failure>(dataDecoder: decoder ?? $0.bodyDecoder)
		}
	}
}

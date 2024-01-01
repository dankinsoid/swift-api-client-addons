import Foundation
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension NetworkClient {

	func bodyEncoder(_ encoder: some ContentEncoder) -> NetworkClient {
		configs(\.bodyEncoder, encoder)
	}

	func bodyDecoder(_ decoder: some DataDecoder) -> NetworkClient {
		configs(\.bodyDecoder, decoder)
	}

	func queryEncoder(_ encoder: some QueryEncoder) -> NetworkClient {
		configs(\.queryEncoder, encoder)
	}
}

public extension NetworkClient.Configs {

	var bodyEncoder: any ContentEncoder {
		get { self[\.bodyEncoder] ?? JSONEncoder() }
		set { self[\.bodyEncoder] = newValue }
	}

	var bodyDecoder: any DataDecoder {
		get { self[\.bodyDecoder] ?? JSONDecoder() }
		set { self[\.bodyDecoder] = newValue }
	}

	var queryEncoder: any QueryEncoder {
		get { self[\.queryEncoder] ?? URLQueryEncoder() }
		set { self[\.queryEncoder] = newValue }
	}
}

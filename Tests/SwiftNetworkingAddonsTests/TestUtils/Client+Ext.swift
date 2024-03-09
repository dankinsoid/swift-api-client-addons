import Foundation
import SwiftNetworking
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension NetworkClient {

	func configs() -> Configs {
		withConfigs { $0 }
	}
}

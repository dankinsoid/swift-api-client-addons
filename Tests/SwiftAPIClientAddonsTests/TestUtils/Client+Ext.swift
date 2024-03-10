import Foundation
import SwiftAPIClient
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension APIClient {

	func configs() -> Configs {
		withConfigs { $0 }
	}
}

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLResponse {

	var isStatusCodeValid: Bool {
		if let response = self as? HTTPURLResponse {
			return response.statusCode >= 200 && response.statusCode < 300
		}
		return false
	}
}

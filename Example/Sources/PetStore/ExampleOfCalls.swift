import Foundation
import SwiftNetworking

// MARK: - Usage example

func exampleOfAPICalls() async throws {
	let api = Petstore(baseURL: .production)

	_ = try await api.pet("some-id").get()
	_ = try await api.pet.findBy(status: .available)
	_ = try await api.store.inventory()
	_ = try await api.user.logout()
	_ = try await api.user("name").delete()
}

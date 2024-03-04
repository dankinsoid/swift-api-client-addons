import Foundation
import SwiftNetworking

struct Petstore {

	// MARK: - BaseURL

	enum BaseURL: String {

		case production = "https://petstore.com"
		case staging = "https://staging.petstore.com"
		case test = "http://localhost:8080"
	}

	var client: NetworkClient

	init(baseURL: BaseURL) {
		client = NetworkClient(baseURL: URL(string: baseURL.rawValue)!)
			.bodyDecoder(.json(dateDecodingStrategy: .iso8601, keyDecodingStrategy: .convertFromSnakeCase))
			.beaerAuth(
				valueFor(
					live: UserDefaultsTokenCacheService(),
					test: MockTokenCacheService()
				)
			)
			.tokenRefresher {
				valueFor(
					live: APITokenRefresher($0),
					test: MockTokenRefresher()
				)
			}
	}
}

// MARK: - "pet" path

extension Petstore {

	var pet: Pet {
		Pet(client: client["pet"])
	}

	struct Pet {

		var client: NetworkClient

		func update(_ pet: PetModel) async throws -> PetModel {
			try await client
				.method(.put)
				.body(pet)
				.call(.http, as: .decodable)
		}

		func add(_ pet: PetModel) async throws -> PetModel {
			try await client
				.method(.post)
				.body(pet)
				.call(.http, as: .decodable)
		}

		func findBy(status: PetStatus) async throws -> [PetModel] {
			try await client["findByStatus"]
				.query("status", status)
				.call(.http, as: .decodable)
		}

		func findBy(tags: [String]) async throws -> [PetModel] {
			try await client["findByTags"]
				.query("tags", tags)
				.call(.http, as: .decodable)
		}

		func callAsFunction(_ id: String) -> PetByID {
			PetByID(client: client.path(id))
		}

		struct PetByID {

			var client: NetworkClient

			func get() async throws -> PetModel {
				try await client.call(.http, as: .decodable)
			}

			func update(name: String?, status: PetStatus?) async throws -> PetModel {
				try await client
					.method(.post)
					.query(["name": name, "status": status])
					.call(.http, as: .decodable)
			}

			func delete() async throws -> PetModel {
				try await client
					.method(.delete)
					.call(.http, as: .decodable)
			}

			func uploadImage(_ image: Data, additionalMetadata: String? = nil) async throws {
				try await client["uploadImage"]
					.method(.post)
					.query("additionalMetadata", additionalMetadata)
					.body(image)
					.headers(.contentType(.application(.octetStream)))
					.call(.http, as: .void)
			}
		}
	}
}

// MARK: - "store" path

extension Petstore {

	var store: Store {
		Store(client: client["store"].auth(enabled: false))
	}

	struct Store {

		var client: NetworkClient

		func inventory() async throws -> [String: Int] {
			try await client["inventory"]
				.auth(enabled: true)
				.call(.http, as: .decodable)
		}

		func order(_ model: OrderModel) async throws -> OrderModel {
			try await client["order"]
				.body(model)
				.method(.post)
				.call(.http, as: .decodable)
		}

		func callAsFunction(_ id: String) -> Order {
			Order(client: client.path("order", id))
		}

		struct Order {

			var client: NetworkClient

			func find() async throws -> OrderModel {
				try await client.call(.http, as: .decodable)
			}

			func delete() async throws -> OrderModel {
				try await client
					.method(.delete)
					.call(.http, as: .decodable)
			}
		}
	}
}

// MARK: "user" path

extension Petstore {

	var user: User {
		User(client: client["user"].auth(enabled: false))
	}

	struct User {

		var client: NetworkClient

		func create(_ model: UserModel) async throws -> UserModel {
			try await client
				.method(.post)
				.body(model)
				.call(.http, as: .decodable)
		}

		func createWith(list: [UserModel]) async throws {
			try await client["createWithList"]
				.method(.post)
				.body(list)
				.call(.http, as: .void)
		}

		func login(username: String, password: String) async throws -> String {
			try await client["login"]
				.query(LoginQuery(username: username, password: password))
				.call(.http, as: .decodable)
		}

		func logout() async throws {
			try await client["logout"].call(.http, as: .void)
		}

		func callAsFunction(_ username: String) -> UserByUsername {
			UserByUsername(client: client.path(username))
		}

		struct UserByUsername {

			var client: NetworkClient

			func get() async throws -> UserModel {
				try await client.call(.http, as: .decodable)
			}

			func update(_ model: UserModel) async throws -> UserModel {
				try await client
					.method(.put)
					.body(model)
					.call(.http, as: .decodable)
			}

			func delete() async throws -> UserModel {
				try await client
					.method(.delete)
					.call(.http, as: .decodable)
			}
		}
	}
}

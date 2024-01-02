import SwiftNetworking
import VDCodable
import XCTest

final class SwiftNetworkingTests: XCTestCase {

	private let client = NetworkClient(baseURL: URL(string: "https://tests.com")!)

	func testConfigs() throws {
		let enabled = client
			.configs(\.testValue, true)
			.withConfigs(\.testValue)

		XCTAssertTrue(enabled)

		let disabled = client
			.configs(\.testValue, false)
			.withConfigs(\.testValue)

		XCTAssertFalse(disabled)
	}

	func exampleOfUsage() async throws {
		let api = Petstore(baseURL: .production, token: "token")

		_ = try await api.pet("some-id").get()
		_ = try await api.pet.findBy(status: .available)
		_ = try await api.store.inventory()
		_ = try await api.user.logout()
		_ = try await api.user("name").delete()
	}
}

extension NetworkClient.Configs {

	var testValue: Bool {
		get { self[\.testValue] ?? false }
		set { self[\.testValue] = newValue }
	}
}

struct Petstore {

	enum BaseURL: String {

		case production = "https://petstore.com"
		case staging = "https://staging.petstore.com"
		case test = "http://localhost:8080"
	}

	var client: NetworkClient

	init(baseURL: BaseURL, token: String) {
		client = NetworkClient(baseURL: URL(string: baseURL.rawValue)!)
			.bodyDecoder(.json(dateDecodingStrategy: .iso8601, keyDecodingStrategy: .convertFromSnakeCase))
			.authToken(token)
	}

	var pet: Pet {
		Pet(client: client["pet"].auth(enabled: true))
	}

	var store: Store {
		Store(client: client["store"])
	}

	var user: User {
		User(client: client["user"])
	}

	struct Pet {

		var client: NetworkClient

		func update(_ pet: PetModel) async throws -> PetModel {
			try await client
				.method(.put)
				.body(pet)
				.http(.decodable)
		}

		func add(_ pet: PetModel) async throws -> PetModel {
			try await client
				.method(.post)
				.body(pet)
				.http(.decodable)
		}

		func findBy(status: PetStatus) async throws -> [PetModel] {
			try await client["findByStatus"]
				.query("status", status)
				.http(.decodable)
		}

		func findBy(tags: [String]) async throws -> [PetModel] {
			try await client["findByTags"]
				.query("tags", tags)
				.http(.decodable)
		}

		func callAsFunction(_ id: String) -> PetByID {
			PetByID(client: client.path(id))
		}

		struct PetByID {

			var client: NetworkClient

			func get() async throws -> PetModel {
				try await client
					.http(.decodable)
			}

			func update(name: String?, status: PetStatus?) async throws -> PetModel {
				try await client
					.method(.post)
					.query(["name": name, "status": status])
					.http(.decodable)
			}

			func delete() async throws -> PetModel {
				try await client
					.method(.delete)
					.http(.decodable)
			}

			func uploadImage(_ image: Data, additionalMetadata: String? = nil) async throws {
				try await client["uploadImage"]
					.method(.post)
					.query("additionalMetadata", additionalMetadata)
					.body(image)
					.headers(.contentType(.application(.octetStream)))
					.http(.void)
			}
		}
	}

	struct Store {

		var client: NetworkClient

		func inventory() async throws -> [String: Int] {
			try await client["inventory"]
				.auth(enabled: true)
				.http(.decodable)
		}

		func order(_ model: OrderModel) async throws -> OrderModel {
			try await client["order"]
				.body(model)
				.method(.post)
				.http(.decodable)
		}

		func callAsFunction(_ id: String) -> Order {
			Order(client: client.path("order", id))
		}

		struct Order {

			var client: NetworkClient

			func find() async throws -> OrderModel {
				try await client
					.http(.decodable)
			}

			func delete() async throws -> OrderModel {
				try await client
					.method(.delete)
					.http(.decodable)
			}
		}
	}

	struct User {

		var client: NetworkClient

		func create(_ model: UserModel) async throws -> UserModel {
			try await client
				.method(.post)
				.body(model)
				.http(.decodable)
		}

		func createWith(list: [UserModel]) async throws {
			try await client["createWithList"]
				.method(.post)
				.body(list)
				.http(.void)
		}

		func login(username: String, password: String) async throws -> String {
			try await client["login"]
				.query(LoginQuery(username: username, password: password))
				.http(.decodable)
		}

		func logout() async throws {
			try await client["logout"].http(.void)
		}

		func callAsFunction(_ username: String) -> UserByUsername {
			UserByUsername(client: client.path(username))
		}

		struct UserByUsername {

			var client: NetworkClient

			func get() async throws -> UserModel {
				try await client
					.http(.decodable)
			}

			func update(_ model: UserModel) async throws -> UserModel {
				try await client
					.method(.put)
					.body(model)
					.http(.decodable)
			}

			func delete() async throws -> UserModel {
				try await client
					.method(.delete)
					.http(.decodable)
			}
		}
	}
}

extension NetworkClient.Configs {

	var authToken: String {
		get { self[\.authToken] ?? "" }
		set { self[\.authToken] = newValue }
	}

	var isAuthEnabled: Bool {
		get { self[\.isAuthEnabled] ?? false }
		set { self[\.isAuthEnabled] = newValue }
	}
}

extension NetworkClient {

	func authToken(_ token: String) -> NetworkClient {
		configs(\.authToken, token)
			.modifyRequest { req, configs in
				if configs.isAuthEnabled {
					req.headers.add(.authorization(bearerToken: configs.authToken))
				}
			}
	}

	func auth(enabled: Bool) -> NetworkClient {
		configs(\.isAuthEnabled, enabled)
	}
}

struct LoginQuery: Codable {

	var username: String
	var password: String
}

struct UserModel: Codable {

	var id: Int
	var username: String
	var firstName: String
	var lastName: String
	var email: String
	var password: String
	var phone: String
	var userStatus: Int
}

struct OrderModel: Codable {

	var id: Int
	var petId: Int
	var quantity: Int
	var shipDate: Date
	var complete: Bool
}

struct PetModel: Codable {

	var id: Int
	var name: String
	var tag: String?
}

enum PetStatus: String, Codable {

	case available
	case pending
	case sold
}

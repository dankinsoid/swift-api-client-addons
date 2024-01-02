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
}

extension NetworkClient.Configs {

	var testValue: Bool {
		get { self[\.testValue] ?? false }
		set { self[\.testValue] = newValue }
	}
}

struct API {

	var client: NetworkClient

	var pets: Pets {
		Pets(client: client.path("pets"))
	}

	struct Pets {

		var client: NetworkClient

		func list() async throws -> JSON {
			try await client
				.query(["hm": 2])
				.body(["hm": 3])
				.method(.delete)
				.http(.json)
		}
	}

	func pet(id: String) -> Pet {
		Pet(client: client.path("pet", id))
	}

	struct Pet {

		var client: NetworkClient

		func list() async throws -> JSON {
			try await client
				.query(["hm": 2])
				.body(["hm": 3])
				.method(.delete)
				.http(.json)
		}
	}
}

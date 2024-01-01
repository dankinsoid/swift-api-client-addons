import SwiftNetworking
import VDCodable
import XCTest

final class SwiftNetworkingTests: XCTestCase {

	private let client = NetworkClient(baseURL: URL(string: "https://tests.com")!)

	func testConfigs() throws {
		let enabledAuth = client
			.enableAuth()
			.withConfigs {
				$0.isAuthEnabled
			}

		XCTAssertTrue(enabledAuth)

		let disabledAuth = client
			.disableAuth()
			.withConfigs {
				$0.isAuthEnabled
			}
            

		XCTAssertFalse(disabledAuth)
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

import Foundation
import SwiftNetworking
import VDCodable
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest

final class ErrorDecodingTests: XCTestCase {

	func testErrorDecoding() throws {
		let errorJSON: JSON = ["error": "test_error"]
		do {
			let _ = try NetworkClient(baseURL: URL(string: "https://example.com")!)
				.errorDecoder(.decodable(ErrorResponse.self))
				.call(.mock(errorJSON.data), as: .decodable(FakeResponse.self))
			XCTFail()
		} catch {
			XCTAssertEqual(error.localizedDescription, "test_error")
		}
	}
}

struct FakeResponse: Codable {

	let anyValue: String
}

struct ErrorResponse: Codable, LocalizedError {

	var error: String?
	var errorDescription: String? { error }
}

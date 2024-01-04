
#if canImport(zlib)
import Foundation
@testable import SwiftNetworking
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest

final class NetworkClientCompressionTests: XCTestCase {

	@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
	func testThatRequestCompressorProperlyCalculatesAdler32() throws {
		let client = NetworkClient(baseURL: URL(string: "https://example.com")!)
			.compressRequest()
		let request = try client.body(Data("Wikipedia".utf8)).request()
		// From https://en.wikipedia.org/wiki/Adler-32
		XCTAssertEqual(request.httpBody, Data([120, 94, 11, 207, 204, 206, 44, 72, 77, 201, 76, 4, 0, 17, 230, 3, 152]))
	}

	@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
	func testThatRequestCompressorDeflatesDataCorrectly() throws {
		let client = NetworkClient(baseURL: URL(string: "https://example.com")!).compressRequest()
		let request = try client.body(Data([0])).request()
		XCTAssertEqual(request.httpBody, Data([0x78, 0x5E, 0x63, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01]))
	}
}
#endif

import XCTest
@testable import TLS

final class TLSTests: XCTestCase {
	func testExample() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		XCTAssertEqual(TLS().text, "Hello, World!")
	}


	static var allTests = [
		("testExample", testExample),
	]
}

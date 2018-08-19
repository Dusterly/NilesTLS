import XCTest
#if !os(macOS)
public let allTests = [
	testCase(ProcessingTests.allTests),
]
#endif

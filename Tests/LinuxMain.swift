import XCTest
import NilesTLSTests

let allTestCases = [
	NilesTLSTests.allTests,
]

XCTMain(allTestCases.flatMap { $0 })

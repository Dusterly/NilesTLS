// swiftlint:disable force_try
// swiftlint:disable force_unwrapping
// swiftlint:disable large_tuple

import XCTest
import Foundation
import HTTP
import Routing
import NilesTLS
import POSIXSockets

class ProcessingTests: XCTestCase {
	func testRespondsOnPOSIXSockets() throws {
		let certificate = TLSCertificate(certificatePath: "Tests/cert.pem", privateKeyPath: "Tests/private_key.pem")
		startProcessing(listeningOn: 8443, certificate: certificate)

		let (error, response, data) = responseToEmptyRequest(at: URL(string: "https://localhost:8443/")!)

		XCTAssertNil(error)
		XCTAssertEqual(response?.statusCode, 200)
		XCTAssertEqual(data, "hello, world".data(using: .ascii))
	}

	private func startProcessing(listeningOn port: InetPort, certificate: TLSCertificate) {
		let socket = try! TLSServerSocket(listeningOn: port, certificate: certificate)
		let router = Router()
		router.respondToRequests(forPath: "/", using: .get) { _ in "hello, world" }
		DispatchQueue.global(qos: .background).async {
			socket.processRequests(routedBy: router)
		}
	}

	private func responseToEmptyRequest(at url: URL) -> (Error?, HTTPURLResponse?, Data?) {
		var error: Error?
		var response: HTTPURLResponse?
		var data: Data?

		let expectation = self.expectation(description: "response")
		let session = Foundation.URLSession(
			configuration: .default,
			delegate: self,
			delegateQueue: nil)
		print("\(url)")
		session.dataTask(with: url) {
			data = $0
			response = $1 as? HTTPURLResponse
			error = $2
			expectation.fulfill()
		}.resume()
		waitForExpectations(timeout: 1)
		return (error, response, data)
	}
}

extension ProcessingTests: NSObjectProtocol {
	public func isEqual(_ object: Any?) -> Bool {
		guard let object = object as? ProcessingTests else { return false }
		return object === self
	}

	public var hash: Int { return 345 }

	public func `self`() -> Self { return self }

	public func isProxy() -> Bool { return false }

	public var description: String { return "ProcessingTests" }
}

extension ProcessingTests: URLSessionDelegate {
	func URLSession(
		_ session: URLSession,
		task: URLSessionTask,
		didReceive challenge: URLAuthenticationChallenge,
		completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential) -> Void) {

		print("challenge \(challenge.protectionSpace)")
//		let credential = URLCredential(trust: trust)
//		completionHandler(.useCredential, credential)
		completionHandler(.performDefaultHandling, URLCredential(user: "", password: "", persistence: .none))
	}
}

extension String: Response {
	public var statusCode: StatusCode { return .ok }
	public var headers: [String: String] { return [:] }
	public var body: Data? { return data(using: .ascii) }
}

extension ProcessingTests {
	static let allTests = [
		("testRespondsOnPOSIXSockets", testRespondsOnPOSIXSockets),
	]
}

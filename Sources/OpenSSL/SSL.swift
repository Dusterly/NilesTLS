import Foundation
import Libssl

public class SSL {
	private let ssl: UnsafeMutablePointer<Libssl.SSL>

	deinit {
		SSL_free(ssl)
	}

	public init(fileDescriptor: Int32, context: SSLContext) throws {
		guard let ssl = SSL_new(context.context) else { throw SSLError.lastError }
		SSL_set_fd(ssl, fileDescriptor)
		self.ssl = ssl
	}

	public func accept() throws {
		try attempt { SSL_accept(ssl) }
	}

	public func read(maxLength: Int) throws -> Data {
		var buffer = [UInt8](repeating: 0, count: maxLength)
		let actualCount =  try attempt { SSL_read(ssl, &buffer, Int32(maxLength)) }
		guard actualCount > 0 else { throw SSLError.noStream }
		return Data(bytes: buffer, count: Int(actualCount))
	}

	public func write(_ data: Data) throws {
		let bytes = Array(data)
		try bytes.withUnsafeBufferPointer {
			guard let baseAddress = $0.baseAddress else { throw SSLError.noStream }
			let sent = try attempt { SSL_write(ssl, baseAddress, Int32(bytes.count)) }
			guard Int(sent) == bytes.count else { throw SSLError.noStream }
		}
	}

	@discardableResult
	private func attempt(_ attemptedCall: () -> Int32) throws -> Int32 {
		let result = attemptedCall()
		let errorCode = SSL_get_error(ssl, result)
		guard errorCode == SSL_ERROR_NONE else { throw SSLError(errorCode) }
		return result
	}
}

import Foundation
import Libssl

public enum SSLError: Error {
	case noStream
	case protocolError
	case zeroReturn

	case withDescription(String)
}

extension SSLError {
	init(_ errorCode: Int32) {
		switch errorCode {
		case SSL_ERROR_SSL:
			self = .protocolError
		case SSL_ERROR_ZERO_RETURN:
			self = .zeroReturn
		default:
			self = .lastError
		}
	}

	static var lastError: SSLError {
		return .withDescription(lastErrorMessage)
	}
}

private extension SSLError {
	static var lastErrorMessage: String {
		var defaultDescription: String { return "Error: \(errno)" }

		guard let cString = strerror(errno) else { return defaultDescription }
		return String(cString: cString, encoding: .ascii) ?? defaultDescription
	}
}

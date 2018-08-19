import Foundation
import Routing
import POSIXSockets
import OpenSSL

public struct TLSClientSocket {
	let socket: POSIXClientSocket
	let ssl: SSL

	init(socket: POSIXClientSocket, context: SSLContext) throws {
		ssl = try SSL(fileDescriptor: socket.descriptor.rawValue, context: context)
		self.socket = socket
	}
}

extension TLSClientSocket: ClientSocket {
	public func negotiateConnection() throws {
		do {
			try ssl.accept()
		} catch let error {
			socket.close()
			throw error
		}
	}

	public func data(readingLength maxLength: Int) throws -> Data {
		return try ssl.read(maxLength: maxLength)
	}

	public func write(_ data: Data) throws {
		try ssl.write(data)
	}

	public func close() {
		socket.close()
	}
}

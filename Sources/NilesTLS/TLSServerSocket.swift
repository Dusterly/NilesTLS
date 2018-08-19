import Glibc
import OpenSSL
import Routing
import POSIXSockets

public struct TLSServerSocket {
	fileprivate let socket: POSIXServerSocket
	fileprivate let context: SSLContext

	public init(listeningOn port: InetPort = 443, certificate: TLSCertificate,
	            maxPendingConnections: Int32 = SOMAXCONN) throws {
		socket = try POSIXServerSocket(listeningOn: port, maxPendingConnections: maxPendingConnections)
		context = try certificate.sslContext()
	}
}

extension TLSServerSocket: ServerSocket {
	public func nextClient() throws -> TLSClientSocket {
		let client = try socket.nextClient()
		return try TLSClientSocket(socket: client, context: context)
	}

	public func close() {
		socket.close()
	}
}

extension TLSCertificate {
	func sslContext() throws -> SSLContext {
		return try SSLContext(
			certificateFile: certificatePath,
			privateKeyFile: privateKeyPath
		)
	}
}

public struct TLSCertificate {
	let certificatePath: String
	let privateKeyPath: String

	public init(certificatePath: String, privateKeyPath: String) {
		self.certificatePath = certificatePath
		self.privateKeyPath = privateKeyPath
	}
}

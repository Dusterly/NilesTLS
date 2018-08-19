import Libssl

public class SSLContext {
	let context: UnsafeMutablePointer<SSL_CTX>

	deinit {
		SSL_CTX_free(context)
		EVP_cleanup()
	}

	public init(certificateFile: String, privateKeyFile: String) throws {
		SSL_library_init()
		SSL_load_error_strings()

		let method = TLSv1_2_server_method()
		guard let context = SSL_CTX_new(method) else {
			throw SSLError.lastError
		}

		self.context = context

		try attempt {
			SSL_CTX_use_certificate_file(context, certificateFile, SSL_FILETYPE_PEM)
		}

		try attempt {
			SSL_CTX_use_RSAPrivateKey_file(context, privateKeyFile, SSL_FILETYPE_PEM)
		}
	}
}

private func attempt(call: () -> Int32) throws {
	if call() != 1 {
		throw SSLError.lastError
	}
}

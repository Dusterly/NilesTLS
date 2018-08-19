FROM swift:4.1.3
ADD . /src
WORKDIR /src
RUN openssl req -x509 -in Tests/cert_request.csr -key Tests/private_key.pem -out Tests/cert.pem -days 1
RUN swift test

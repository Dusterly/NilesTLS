// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "TLS",
	products: [
		.library(
			name: "TLS",
			targets: ["TLS"]),
	],
	dependencies: [
		.package(url: "https://bitbucket.org/sdbip/niles.git", from: "0.1.0"),
	],
	targets: [
		.target(
			name: "TLS",
			dependencies: ["HTTP"]),
		.testTarget(
			name: "TLSTests",
			dependencies: ["TLS"]),
	]
)

// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NilesTLS",
	products: [
		.library(
			name: "NilesTLS",
			targets: ["NilesTLS"]),
	],
	dependencies: [
		.package(url: "https://bitbucket.org/sdbip/niles.git", from: "0.1.0"),
	],
	targets: [
		.target(
			name: "NilesTLS",
			dependencies: ["Routing", "POSIXSockets", "OpenSSL"]),
		.testTarget(
			name: "NilesTLSTests",
			dependencies: ["NilesTLS"]),

		.target(
			name: "OpenSSL",
			dependencies: ["Libssl"]),

		.target(
			name: "Libssl",
			dependencies: []),
	]
)

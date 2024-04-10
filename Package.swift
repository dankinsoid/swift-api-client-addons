// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
	name: "swift-api-client-addons",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.watchOS(.v5),
		.tvOS(.v13),
	],
	products: [
		.library(name: "SwiftAPIClientAddons", targets: ["SwiftAPIClientAddons"]),
	],
	dependencies: [
		.package(url: "https://github.com/dankinsoid/swift-api-client.git", from: "1.6.1"),
		.package(url: "https://github.com/dankinsoid/swift-json.git", from: "0.1.0"),
	],
	targets: [
		.target(
			name: "SwiftAPIClientAddons",
			dependencies: [
				.product(name: "SwiftAPIClient", package: "swift-api-client"),
				.product(name: "SwiftJSON", package: "swift-json"),
			]
		),
		.testTarget(
			name: "SwiftAPIClientAddonsTests",
			dependencies: [.target(name: "SwiftAPIClientAddons")]
		),
	]
)

#if os(Linux)
#else
package.dependencies.append(
	.package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6")
)
package.targets.append(
	.target(
		name: "SwiftAPIClientWebSocket",
		dependencies: [
			.target(name: "SwiftAPIClientAddons"),
			.product(name: "Starscream", package: "Starscream"),
		]
	)
)
package.targets.append(
	.testTarget(
		name: "SwiftAPIClientWebSocketTests",
		dependencies: [.target(name: "SwiftAPIClientWebSocket")]
	)
)
#endif

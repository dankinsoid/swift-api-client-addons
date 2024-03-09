// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
	name: "swift-networking",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.watchOS(.v5),
		.tvOS(.v13),
	],
	products: [
		.library(name: "SwiftNetworking", targets: ["SwiftNetworking"]),
	],
	dependencies: [
		.package(url: "https://github.com/dankinsoid/swift-networking-core.git", from: "0.22.2"),
		.package(url: "https://github.com/dankinsoid/swift-json.git", from: "0.1.0"),
		.package(url: "https://github.com/dankinsoid/MultipartFormDataKit.git", from: "1.0.2"),
	],
	targets: [
		.target(
			name: "SwiftNetworking",
			dependencies: [
				.product(name: "SwiftNetworkingCore", package: "swift-networking-core"),
				.product(name: "SwiftJSON", package: "swift-json"),
				.product(name: "MultipartFormDataKit", package: "MultipartFormDataKit"),
			]
		),
		.testTarget(
			name: "SwiftNetworkingTests",
			dependencies: [.target(name: "SwiftNetworking")]
		),
	]
)

#if os(Linux)
#else
package.dependencies.append(
	.package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.6")
)
package.dependencies.append(
	.package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0")
)
package.targets[0].dependencies.append(
	.product(name: "Reachability", package: "Reachability.swift")
)
package.targets.append(
	.target(
		name: "SwiftNetworkingWebSocket",
		dependencies: [
			.target(name: "SwiftNetworking"),
			.product(name: "Starscream", package: "Starscream"),
		]
	)
)
package.targets.append(
	.testTarget(
		name: "SwiftNetworkingWebSocketTests",
		dependencies: [.target(name: "SwiftNetworkingWebSocket")]
	)
)
#endif

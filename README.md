# swift-api-client-addons
This library extends [swift-api-client](https://github.com/dankinsoid/swift-api-client) to make it a more universal tool.

## WebSocket
The library offers a straightforward approach to handling WebSockets, utilizing the [Starscream](https://github.com/daltoniam/Starscream.git) library.
```swift
let channel: WebSocketChannel<Item> = try client.call(.webSocket, as: .decodable)
for try await item in channel {
    ...
}
```
## Reachability Monitoring
Facilitates network reachability monitoring, leveraging the [Reachability](https://github.com/ashleymills/Reachability.swift) library.
```swift
let newClient = client.waitForConnection()
```
## JSON API
Integrates the [swift-json](https://github.com/dankinsoid/swift-json) library for easy JSON API interactions.
```swift
let json = try client.body(bodyJSON).call(.http, as: .json)
```
## `.retryWhenEnterForeground()`  Modifier
Enables retrying a request when the app re-enters the foreground after being interrupted by transitioning to the background.

## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/swift-api-client-addons.git", from: "0.13.0")
  ],
  targets: [
    .target(
      name: "SomeProject",
      dependencies: [
        .product(name:  "SwiftAPIClientAddons", package: "swift-api-client-addons"),
      ]
    )
  ]
)
```
```ruby
$ swift build
```

## Author

dankinsoid, voidilov@gmail.com

## License

swift-api-client-addons is available under the MIT license. See the LICENSE file for more info.

## Contributing
We welcome contributions to swift-api-client-addons! Please read our contributing guidelines to get started.

# swift-networking-addons
This library extends [swift-networking](https://github.com/dankinsoid/swift-networking) to make it a more universal tool.

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
## Multipart Form Data
Simplifies multipart form data handling, based on the on [MultipartFormDataKit](https://github.com/dankinsoid/MultipartFormDataKit.git) library.
```swift
client.body(someEncodable, as: .multipartFormData)
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
    .package(url: "https://github.com/dankinsoid/swift-networking-addons.git", from: "0.10.0")
  ],
  targets: [
    .target(
      name: "SomeProject",
      dependencies: [
        .product(name:  "SwiftNetworkingAddons", package: "swift-networking-addons"),
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

swift-networking is available under the MIT license. See the LICENSE file for more info.

## Contributing
We welcome contributions to Swift-Networking! Please read our contributing guidelines to get started.

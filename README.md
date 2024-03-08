# swift-networking

## Overview
Swift-Networking is a modern, comprehensive, and modular networking library for Swift. Designed with a focus on extensibility and reusability, it simplifies building and managing complex networking tasks in your Swift applications. The library supports a wide range of networking needs, from HTTP requests to WebSocket communication, and is easily testable and mockable.

Swift-networking focuses on extensibility and reusability of all configs. The root of the library is NetworkClient struct. The main idea is that you can create a client with a base URL and then create new clients from it, which will inherit all the settings of the parent client. For example, you can create a client for the API with the base URL "https://api.github.com" and then create a client for the API with the base URL "https://api.github.com/users" from it. The second client will inherit all the settings of the first client, but you can override them if necessary. 
There is a list of all implemented configs.
// TODO: finish
Basically NetworkClient is a combination of two components: a closure to create a URLReauest and a dictionory of configs. So there is two ways to extend a NetworkClient.
- Add a new config.
- Add a new URLRequest modifier.

## Usage
Below is an example of using Swift-Networking to create an API client for a [Petstore](https://petstore3.swagger.io):

```swift
struct Petstore {

  var client: NetworkClient

  init(baseURL: URL, token: String) {
    client = NetworkClient(baseURL: baseURL)
      .bodyDecoder(.json(dateDecodingStrategy: .iso8601, keyDecodingStrategy: .convertFromSnakeCase))
      .auth(.bearer(token: token))
  }

  var pet: Pet {
    Pet(client: client("pet"))
  }

  var store: Store {
    Store(client: client("store").auth(enabled: false))
  }

  struct Pet {

    var client: NetworkClient

    /// PUT /pet
    func update(_ pet: PetModel) async throws -> PetModel {
      try await client.put
        .body(pet)
        .call(.http, as: .decodable)
    }

    /// POST /pet
    func add(_ pet: PetModel) async throws -> PetModel {
      try await client.post
        .body(pet)
        .call() // .http and .decodable are default values, so can be missed.
    }
  }

  struct Store {

    var client: NetworkClient

    /// GET /store/inventory
    func inventory() async throws -> [String: Int] {
      try await client("inventory").call()
    }

    /// POST /store/order
    func order(_ model: OrderModel) async throws -> OrderModel {
      try await client("order").body(model).post()
    }
  }
}

// MARK: - Usage example

func exampleOfUsage() async throws {
    let api = Petstore(baseURL: .production, token: "token")
    // ...
    _ = try await api.update(model)
    _ = try await api.store.inventory()
}
```

This example demonstrates how to configure and use various aspects of the library, such as configuring endpoints, handling authentication, and processing responses.

## Customization
The library is designed for flexibility and can be easily customized to suit different networking needs:

- **Custom Encoders and Decoders**: Easily implement custom logic for request and response processing.
- **Authentication Handling**: Seamlessly integrate authentication mechanisms.
- **Error Handling and Logging**: Customize how errors are handled and logged.

## Testing
Swift-Networking supports easy testing and mocking of network clients, making it simple to write unit tests for your networking code.

## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/swift-networking.git", from: "0.8.0")
  ],
  targets: [
    .target(
      name: "SomeProject",
      dependencies: [
        .product(name:  "SwiftNetworking", package: "swift-networking"),
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

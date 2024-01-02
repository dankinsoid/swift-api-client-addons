# swift-networking

## Overview
Swift-Networking is a modern, comprehensive, and modular networking library for Swift. Designed with a focus on extensibility and reusability, it simplifies building and managing complex networking tasks in your Swift applications. The library supports a wide range of networking needs, from HTTP requests to WebSocket communication, and is easily testable and mockable.

## Key Features
- **Modular Design**: Build complex networking clients with reusable and interchangeable components.
- **Comprehensive Configuration**: Extensive support for custom configurations, including headers, query parameters, and body content.
- **WebSocket Support**: Integrated support for WebSocket connections.
- **Async/Await Ready**: Leverages Swift's concurrency model for clear and concise asynchronous code.
- **Error Handling**: Robust error handling and logging mechanisms.
- **Testing and Mocking**: Facilitates easy testing with mock services and clients.

## Installation
[Instructions for installing and integrating the library in a Swift project]

## Usage
Below is an example of using Swift-Networking to create an API client for a Petstore:

```swift
struct Petstore {

  enum BaseURL: String {

    case production = "https://petstore.com"
    case staging = "https://staging.petstore.com"
    case test = "http://localhost:8080"
  }

  var client: NetworkClient

  init(baseURL: BaseURL, token: String) {
    client = NetworkClient(baseURL: URL(string: baseURL.rawValue)!)
      .bodyDecoder(.json(dateDecodingStrategy: .iso8601, keyDecodingStrategy: .convertFromSnakeCase))
      .authToken(token)
  }

  var pet: Pet {
    Pet(client: client["pet"].auth(enabled: true))
  }

  var store: Store {
    Store(client: client["store"])
  }

  var user: User {
    User(client: client["user"])
  }

  struct Pet {

    var client: NetworkClient

    func update(_ pet: PetModel) async throws -> PetModel {
      try await client
        .method(.put)
        .body(pet)
        .http(.decodable)
    }

    func add(_ pet: PetModel) async throws -> PetModel {
      try await client
        .method(.post)
        .body(pet)
        .http(.decodable)
    }

    func findBy(status: PetStatus) async throws -> [PetModel] {
      try await client["findByStatus"]
        .query("status", status)
        .http(.decodable)
    }

    func findBy(tags: [String]) async throws -> [PetModel] {
      try await client["findByTags"]
        .query("tags", tags)
        .http(.decodable)
    }

    func callAsFunction(_ id: String) -> PetByID {
      PetByID(client: client.path(id))
    }

    struct PetByID {

      var client: NetworkClient

      func get() async throws -> PetModel {
        try await client
          .http(.decodable)
      }

      func update(name: String?, status: PetStatus?) async throws -> PetModel {
        try await client
          .method(.post)
          .query(["name": name, "status": status])
          .http(.decodable)
      }

      func delete() async throws -> PetModel {
        try await client
          .method(.delete)
          .http(.decodable)
      }

      func uploadImage(_ image: Data, additionalMetadata: String? = nil) async throws {
        try await client["uploadImage"]
          .method(.post)
          .query("additionalMetadata", additionalMetadata)
          .body(image)
          .headers(.contentType(.application(.octetStream)))
          .http(.void)
      }
    }
  }

  struct Store {

    var client: NetworkClient

    func inventory() async throws -> [String: Int] {
      try await client["inventory"]
        .auth(enabled: true)
        .http(.decodable)
    }

    func order(_ model: OrderModel) async throws -> OrderModel {
      try await client["order"]
        .body(model)
        .method(.post)
        .http(.decodable)
    }

    func callAsFunction(_ id: String) -> Order {
      Order(client: client.path("order", id))
    }

    struct Order {

      var client: NetworkClient

      func find() async throws -> OrderModel {
        try await client
          .http(.decodable)
      }

      func delete() async throws -> OrderModel {
        try await client
          .method(.delete)
          .http(.decodable)
      }
    }
  }

  struct User {

    var client: NetworkClient

    func create(_ model: UserModel) async throws -> UserModel {
      try await client
        .method(.post)
        .body(model)
        .http(.decodable)
    }

    func createWith(list: [UserModel]) async throws {
      try await client["createWithList"]
        .method(.post)
        .body(list)
        .http(.void)
    }

    func login(username: String, password: String) async throws -> String {
      try await client["login"]
        .query(LoginQuery(username: username, password: password))
        .http(.decodable)
    }

    func logout() async throws {
      try await client["logout"].http(.void)
    }

    func callAsFunction(_ username: String) -> UserByUsername {
      UserByUsername(client: client.path(username))
    }

    struct UserByUsername {

      var client: NetworkClient

      func get() async throws -> UserModel {
        try await client
          .http(.decodable)
      }

      func update(_ model: UserModel) async throws -> UserModel {
        try await client
          .method(.put)
          .body(model)
          .http(.decodable)
      }

      func delete() async throws -> UserModel {
        try await client
          .method(.delete)
          .http(.decodable)
      }
    }
  }
}

extension NetworkClient.Configs {

  var authToken: String {
    get { self[\.authToken] ?? "" }
    set { self[\.authToken] = newValue }
  }

  var isAuthEnabled: Bool {
    get { self[\.isAuthEnabled] ?? false }
    set { self[\.isAuthEnabled] = newValue }
  }
}

extension NetworkClient {

  func authToken(_ token: String) -> NetworkClient {
    configs(\.authToken, token)
      .modifyRequest { req, configs in
        if configs.isAuthEnabled {
          req.headers.add(.authorization(bearerToken: configs.authToken))
        }
      }
  }

  func auth(enabled: Bool) -> NetworkClient {
    configs(\.isAuthEnabled, enabled)
  }
}

// MARK: - Usage example

func exampleOfUsage() async throws {
    let api = Petstore(baseURL: .production, token: "token")

    _ = try await api.pet("some-id").get()
    _ = try await api.pet.findBy(status: .available)
    _ = try await api.store.inventory()
    _ = try await api.user.logout()
    _ = try await api.user("name").delete()
}
```

This example demonstrates how to configure and use various aspects of the library, such as configuring endpoints, handling authentication, and processing responses.

## Customization
The library is designed for flexibility and can be easily customized to suit different networking needs:

- **Custom Encoders and Decoders**: Easily implement custom logic for request and response processing.
- **Authentication Handling**: Seamlessly integrate authentication mechanisms.
- **Error Handling and Logging**: Customize how errors are handled and logged.
- [Other customization options]

## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/swift-networking.git", from: "0.1.0")
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

## Testing
Swift-Networking supports easy testing and mocking of network clients, making it simple to write unit tests for your networking code.

## Contributing
We welcome contributions to Swift-Networking! Please read our contributing guidelines to get started.

# swift-networking

## Description
This repository provides reach and flexible networking layer for client Swift applications.

## Example

```swift
struct API {

    let client = NetworkClient(baseURL: URL(string: "https://pets.com")!)
    
    var pets: Pets {
        Pets(client: client.path("pets"))
    }
  
    struct Pets {
    
        var client: NetworkClient
    
        func list() async throws -> JSON {
            try await client
                .query(ListQuery(limit: 100))
                .body(ListBody())
                .method(.delete)
                .json()
        }
    }

    func pet(id: String) -> Pet {
        Pet(client: client.path("pet", id))
    }
  
    struct Pet {

        var client: NetworkClient
  
        func update(pet: PetModel) async throws -> JSON {
            try await client
                .body(UpdateBody(pet: pet))
                .method(.post)
                .json()
        }
    }
}

```
## Usage

 
## Installation

1. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/swift-networking.git", from: "0.0.1")
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

import Foundation
import Logging

public extension NetworkClient {

	struct Configs {

		private var values: [PartialKeyPath<NetworkClient.Configs>: Any] = [:]

		public init() {}

		public subscript<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>) -> T? {
			get { values[keyPath] as? T }
			set { values[keyPath] = newValue }
		}

		public func with<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>, _ value: T) -> NetworkClient.Configs {
			var result = self
			result[keyPath: keyPath] = value
			return result
		}
	}
}

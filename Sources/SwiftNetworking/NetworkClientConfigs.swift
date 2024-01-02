import Foundation
import Logging

public extension NetworkClient {

	/// A struct representing the configuration settings for a `NetworkClient`.
	struct Configs {

		private var values: [PartialKeyPath<NetworkClient.Configs>: Any] = [:]

		/// Initializes a new configuration set for `NetworkClient`.
		public init() {}

		/// Provides subscript access to configuration values based on their key paths.
		/// - Parameter keyPath: A `WritableKeyPath` to the configuration property.
		/// - Returns: The value of the configuration property if it exists, or `nil` otherwise.
		public subscript<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>) -> T? {
			get { values[keyPath] as? T }
			set { values[keyPath] = newValue }
		}

		/// Returns a new `Configs` instance with a modified configuration value.
		/// - Parameters:
		///   - keyPath: A `WritableKeyPath` to the configuration property to be modified.
		///   - value: The new value to set for the specified configuration property.
		/// - Returns: A new `Configs` instance with the updated configuration setting.
		public func with<T>(_ keyPath: WritableKeyPath<NetworkClient.Configs, T>, _ value: T) -> NetworkClient.Configs {
			var result = self
			result[keyPath: keyPath] = value
			return result
		}
	}
}

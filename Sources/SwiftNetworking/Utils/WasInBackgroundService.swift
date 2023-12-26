#if canImport(UIKit)
import Foundation
import UIKit

public protocol WasInBackgroundService {

	var wasInBackground: Bool { get }
	func start()
	func reset()
}

public struct MockWasInBackgroundService: WasInBackgroundService {

	public var wasInBackground: Bool

	public init(wasInBackground: Bool = false) {
		self.wasInBackground = wasInBackground
	}

	public func start() {}

	public func reset() {}
}

public final class DefaultWasInBackgroundService: WasInBackgroundService {

	public private(set) var wasInBackground = false
	private var observer: NSObjectProtocol?

	public init() {
		start()
	}

	public func start() {
		guard observer == nil else { return }
		observer = NotificationCenter.default.addObserver(
			forName: UIApplication.didEnterBackgroundNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			self?.wasInBackground = true
		}
	}

	public func reset() {
		wasInBackground = false
	}
}
#endif

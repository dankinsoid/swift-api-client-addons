import Foundation
import Reachability

public protocol ReachabilityService {

	var connection: Reachability.Connection { get }
	func wait(for connection: @escaping (Reachability.Connection) -> Bool) async
}

public extension ReachabilityService {

	var isReachable: Bool {
		connection != .unavailable
	}

	func wait(for connection: Reachability.Connection) async {
		await wait {
			$0 == connection
		}
	}

	func waitReachable() async {
		await wait {
			$0 != .unavailable
		}
	}
}

public struct MockReachabilityService: ReachabilityService {

	public var connection: Reachability.Connection

	public init(connection: Reachability.Connection = .wifi) {
		self.connection = connection
	}

	public func wait(for connection: @escaping (Reachability.Connection) -> Bool) async {}
}

public final actor DefaultReachabilityService: ReachabilityService {

	public static let shared = DefaultReachabilityService()

	public nonisolated var connection: Reachability.Connection {
		reachability?.connection ?? .unavailable
	}

	public init(reachability: Reachability?) {
		self.reachability = reachability
	}

	private let reachability: Reachability?
	private var didStart = false
	private var subscribers: [(Reachability.Connection) -> Bool] = []

	public init() {
		self.init(reachability: try? Reachability())
	}

	public func wait(for connection: @escaping (Reachability.Connection) -> Bool) async {
		guard !connection(self.connection) else { return }
		startIfNeeded()
		await withCheckedContinuation {
			subscribe(condition: connection, continuation: $0)
		}
	}

	private func startIfNeeded() {
		try? reachability?.startNotifier()
		guard let reachability, !didStart else { return }
		didStart = true
		let currentWhenReachable = reachability.whenReachable
		reachability.whenReachable = { [weak self] reachability in
			currentWhenReachable?(reachability)
			Task { [weak self] in
				await self?.update(with: reachability)
			}
		}
		let currentWhenUnreachable = reachability.whenUnreachable
		reachability.whenUnreachable = { [weak self] reachability in
			currentWhenUnreachable?(reachability)
			Task { [weak self] in
				await self?.update(with: reachability)
			}
		}
	}

	private func update(with reachability: Reachability) {
		subscribers = subscribers.filter {
			!$0(reachability.connection)
		}
	}

	private func subscribe(condition: @escaping (Reachability.Connection) -> Bool, continuation: CheckedContinuation<Void, Never>) {
		subscribers.append {
			if condition($0) {
				continuation.resume()
				return true
			}
			return false
		}
	}
}

public extension ReachabilityService where Self == DefaultReachabilityService {

	static var `default`: DefaultReachabilityService {
		.shared
	}
}

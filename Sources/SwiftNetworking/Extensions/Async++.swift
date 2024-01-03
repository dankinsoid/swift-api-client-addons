import Foundation

public struct AsyncSequenceOfElements<S: Sequence>: AsyncSequence {

	public typealias AsyncIterator = AsyncStream<S.Element>.AsyncIterator
	public typealias Element = S.Element

	let sequence: S

	public init(_ sequence: S) {
		self.sequence = sequence
	}

	public func makeAsyncIterator() -> AsyncStream<S.Element>.AsyncIterator {
		AsyncStream { cont in
			for element in sequence {
				cont.yield(element)
			}
			cont.finish()
		}
		.makeAsyncIterator()
	}
}

public extension Sequence {

	var async: AsyncSequenceOfElements<Self> {
		AsyncSequenceOfElements(self)
	}
}

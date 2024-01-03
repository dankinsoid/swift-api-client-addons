import Foundation

struct AsyncSequenceOfElements<S: Sequence>: AsyncSequence {

	typealias AsyncIterator = AsyncStream<S.Element>.AsyncIterator
	typealias Element = S.Element

	let sequence: S

	init(_ sequence: S) {
		self.sequence = sequence
	}

	func makeAsyncIterator() -> AsyncStream<S.Element>.AsyncIterator {
		AsyncStream { cont in
			for element in sequence {
				cont.yield(element)
			}
			cont.finish()
		}
		.makeAsyncIterator()
	}
}

extension Sequence {

	var async: AsyncSequenceOfElements<Self> {
		AsyncSequenceOfElements(self)
	}
}

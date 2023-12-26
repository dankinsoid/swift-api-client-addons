import Foundation

public struct AnyAsyncSequence<Element>: AsyncSequence {
    
    private var _makeAsyncIterator: () -> AsyncIterator
    
    public init(makeAsyncIterator: @escaping () -> AsyncIterator) {
        _makeAsyncIterator = makeAsyncIterator
    }
    
    public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        self.init {
            var iterator = sequence.makeAsyncIterator()
            return AsyncIterator {
                try await iterator.next()
            }
        }
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        _makeAsyncIterator()
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        
        private var _next: () async throws -> Element?
        
        public init(next: @escaping () async throws -> Element?) {
            _next = next
        }
        
        public mutating func next() async throws -> Element? {
            try await _next()
        }
    }
}

extension AsyncSequence {
    
    public func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Element> {
        AnyAsyncSequence(self)
    }
}

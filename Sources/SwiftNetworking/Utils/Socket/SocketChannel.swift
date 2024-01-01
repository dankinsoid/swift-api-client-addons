import Foundation

public struct WebSocketChannel<Element>: AsyncSequence {

    private let sequence: AnyAsyncSequence<Element>
    private let sendData: (Data) async throws -> Void
    private let sendString: (String) async throws -> Void

    public init<S: AsyncSequence>(
        _ sequence: S,
        sendData: @escaping (Data) async throws -> Void,
        sendString: @escaping (String) async throws -> Void
    ) where S.Element == Element {
        self.sequence = sequence.eraseToAnyAsyncSequence()
        self.sendData = sendData
        self.sendString = sendString
    }

    public func makeAsyncIterator() -> AnyAsyncSequence<Element>.AsyncIterator {
        sequence.makeAsyncIterator()
    }

    public func send(_ data: Data) async throws {
        try await sendData(data)
    }

    public func send(_ string: String) async throws {
        try await sendString(string)
    }

    public func send(_ value: any Encodable, encoder: some ContentEncoder) async throws {
        guard let string = try String(data: encoder.encode(value), encoding: .utf8) else {
            throw Errors.invalidUTF8Data
        }
        try await sendString(string)
    }

    public func map<T>(
        _ transform: @escaping (Element) async throws -> T
    ) -> WebSocketChannel<T> {
        WebSocketChannel<T>(
            sequence.map(transform),
            sendData: sendData,
            sendString: sendString
        )
    }
}

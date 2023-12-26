import Foundation
import Starscream

public final actor WebSocketStream: AsyncSequence {
    
    public typealias Element = Data
    public typealias AsyncIterator = AsyncThrowingStream<Data, Error>.AsyncIterator
    public let webSocket: WebSocket
    public let pingInterval: Double
    private var continuations: [UUID: AsyncThrowingStream<Data, Error>.Continuation] = [:]
    private var pingTask: Task<Void, Error>?
    public private(set) var isConnected = false
    public private(set) var isFinished = false
    
    public init(
        _ webSocket: WebSocket,
        pingInterval: Double = 15.0
    ) {
        self.webSocket = webSocket
        self.pingInterval = pingInterval
        webSocket.onEvent = didReceive
    }
    
    public nonisolated func makeAsyncIterator() -> AsyncThrowingStream<Data, Error>.AsyncIterator {
        AsyncThrowingStream<Data, Error> { [self] continuation in
            Task {
                await receive(continuation: continuation)
            }
        }
        .makeAsyncIterator()
    }
    
    private func receive(continuation: AsyncThrowingStream<Data, Error>.Continuation) {
        guard !isFinished else {
            continuation.finish()
            return
        }
        let id = UUID()
        continuation.onTermination = { [weak self] _ in
            Task { [self] in
                await self?.onTerminate(id: id)
            }
        }
        continuations[id] = continuation
        guard !isConnected else {
            return
        }
        pingTask = Task.detached { [weak self, pingInterval] in
            while !Task.isCancelled {
                try await Task.sleep(nanoseconds: UInt64(pingInterval * 1_000_000_000))
                self?.webSocket.write(ping: Data())
            }
        }
        webSocket.connect()
        isConnected = true
    }
    
    private func finish(throwing error: Error? = nil) {
        guard !isFinished else { return }
        webSocket.onEvent = nil
        isFinished = true
        pingTask?.cancel()
        pingTask = nil
        continuations.forEach { $0.value.finish(throwing: error) }
        continuations = [:]
        webSocket.disconnect()
        isConnected = false
    }
    
    private func onSend(data: Data) {
        continuations = continuations.filter {
            switch $0.value.yield(data) {
            case let .enqueued(remaining):
                if remaining > 0 {
                    return true
                }
            case .dropped, .terminated:
                break
            @unknown default:
                return true
            }
            $0.value.finish()
            return false
        }
        if continuations.isEmpty {
            finish()
        }
    }
    
    private func onTerminate(id: UUID) {
        continuations[id] = nil
        if continuations.isEmpty {
            finish()
        }
    }
}

private extension WebSocketStream {
    
    func didConnect() {
        isConnected = true
    }
    
    func didDisconnect() {
        finish()
    }
    
    func viabilityDidChange(isViable: Bool) {}
    
    func didReceiveError(error: Error?) {
        finish(throwing: error)
    }
    
    func didReceivePong() {}
    
    func didReceiveMessage(string: String) {
        didReceiveMessage(data: Data(string.utf8))
    }
    
    func didReceiveMessage(data: Data) {
        onSend(data: data)
    }
}

public extension WebSocket {
    
    var stream: WebSocketStream { WebSocketStream(self) }
}

extension WebSocketStream {
    
    public nonisolated func didReceive(event: WebSocketEvent) {
        Task {
            await receive(event: event)
        }
    }
    
    private func receive(event: WebSocketEvent) {
        switch event {
        case .connected:
            didConnect()
        case .disconnected:
            didDisconnect()
        case let .text(string):
            didReceiveMessage(string: string)
        case let .binary(data):
            didReceiveMessage(data: data)
        case .pong:
            didReceivePong()
        case .ping:
            break
        case let .error(error):
            didReceiveError(error: error)
        case let .viabilityChanged(isViable):
            viabilityDidChange(isViable: isViable)
        case .reconnectSuggested:
            break
        case .cancelled:
            didDisconnect()
        case .peerClosed:
            didDisconnect()
        }
    }
}

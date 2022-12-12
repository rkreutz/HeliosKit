import Foundation

public final class Helios {

    public static let shared = Helios()

    private enum Constants {
        static let port: UInt16 = 8545
    }

    public var clientURL: URL { URL(string: "http://127.0.0.1:\(Constants.port)").unsafelyUnwrapped }

    private let client: HeliosClient = .init()

    public func start(
        rpcURL: URL,
        consensusURL: URL = URL(string: "https://www.lightclientdata.org").unsafelyUnwrapped,
        checkpoint: String? = nil,
        network: Network = .mainnet
    ) async throws {
        let status = await client.start(
            rpcURL.absoluteString,
            consensusURL.absoluteString,
            checkpoint,
            Constants.port,
            network.asHeliosNetwork()
        )

        if !status.started {
            throw HeliosError.failedToStartClient(status.error.toString())
        }
    }

    @available(iOS 15.0, *)
    public func call(method: String, params: [String]) async throws -> (data: Data, response: URLResponse) {
        try await self.call(method: method, params: params, id: UUID())
    }

    @available(iOS 15.0, *)
    public func call<ID: CustomStringConvertible>(method: String, params: [String], id: ID) async throws -> (data: Data, response: URLResponse) {
        var request = URLRequest(url: clientURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
        {
            "jsonrpc": "2.0",
            "method": "\(method)",
            "params": \(params),
            "id": "\(id.description)"
        }
        """.data(using: .utf8)
        return try await URLSession.shared.data(for: request)
    }

    public func shutdown() async {
        await client.shutdown()
    }
}

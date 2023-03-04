import Foundation

public final class Helios {

    public static let shared = Helios()

    public static let defaultDataDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    private enum Constants {
        static let port: UInt16 = 8545
    }

    public var clientURL: URL { URL(string: "http://127.0.0.1:\(Constants.port)").unsafelyUnwrapped }

    private let client: HeliosClient = .init()

    /// Starts the Helios client
    /// - Parameters:
    ///   - rpcURL: the unsafe execution RPC URL
    ///   - consensusURL: the consensus RPC URL
    ///   - checkpoint: an optional verified checkpoint. If not provided will try to fetch latest checkpoint from `dataDirectoryPath`.
    ///   - network: the network to connect to.
    ///   - dataDirectory: the directory to save data related to Helios. If `nil` no data will be saved across launches of Helios.
    public func start(
        rpcURL: URL,
        consensusURL: URL = URL(string: "https://www.lightclientdata.org").unsafelyUnwrapped,
        checkpoint: String? = nil,
        network: Network = .mainnet,
        dataDirectory: URL? = Helios.defaultDataDirectory
    ) async throws {
        var _checkpoint: String?
        if let checkpoint = checkpoint {
            _checkpoint = checkpoint
        } else if let dataDirectory = dataDirectory {
            let checkpointFile: URL
            if #available(iOS 16.0, macOS 13.0, *) {
                checkpointFile = dataDirectory.appending(path: "checkpoint")
            } else {
                checkpointFile = dataDirectory.appendingPathComponent("checkpoint")
            }
            _checkpoint = (try? Data(contentsOf: checkpointFile))?.hexEncodedString()
        }

        let dataDirectoryPath: String?
        if #available(iOS 16.0, macOS 13.0, *) {
            dataDirectoryPath = dataDirectory?.path()
        } else {
            dataDirectoryPath = dataDirectory?.path
        }

        let status = await client.start(
            rpcURL.absoluteString,
            consensusURL.absoluteString,
            _checkpoint,
            Constants.port,
            network.asHeliosNetwork(),
            dataDirectoryPath
        )

        if !status.started {
            throw HeliosError.failedToStartClient(status.error.toString())
        }
    }

    /// Makes an RPC call to the Helios client. An arbitrary ID will be assigned to the call.
    /// - Parameters:
    ///   - method: the RPC method to call
    ///   - params: the params related to the method
    /// - Returns: the response of the RPC call
    public func call(method: String, params: [String]) async throws -> (data: Data, response: URLResponse) {
        try await self.call(method: method, params: params, id: UUID())
    }

    /// Makes an RPC call to the Helios client
    /// - Parameters:
    ///   - method: the RPC method to call
    ///   - params: the params related to the method
    ///   - id: an ID that should be associated with the call
    /// - Returns: the response of the RPC call
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

    /// Shuts down the client
    public func shutdown() async {
        await client.shutdown()
    }
}

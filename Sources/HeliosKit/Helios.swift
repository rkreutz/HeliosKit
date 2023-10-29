import Foundation

public final class Helios {

    public static let shared = Helios()

    public static let defaultDataDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    public enum Defaults {
        public static let ip: String = "127.0.0.1"
        public static let port: UInt16 = 8545
    }

    public var clientURL: URL { URL(string: "http://\(ip):\(port)").unsafelyUnwrapped }

    private let client: HeliosClient = .init()
    private var ip: String = Defaults.ip
    private var port: UInt16 = Defaults.port

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
        localRpcIp: String = Defaults.ip,
        localRpcPort: UInt16 = Defaults.port,
        network: Network = .mainnet,
        dataDirectory: URL? = Helios.defaultDataDirectory
    ) async throws {
        let dataDirectoryPath: String?
        if #available(iOS 16.0, macOS 13.0, *) {
            dataDirectoryPath = dataDirectory?.path()
        } else {
            dataDirectoryPath = dataDirectory?.path
        }

        if let dataDirectoryPath = dataDirectoryPath {
            if !FileManager.default.isWritableFile(atPath: dataDirectoryPath) {
                throw HeliosError.dataDirectoryNotAvailable
            }
        }

        let status = await client.start(
            rpcURL.absoluteString,
            consensusURL.absoluteString,
            checkpoint,
            localRpcIp,
            localRpcPort,
            network.asHeliosNetwork(),
            dataDirectoryPath
        )

        if !status.started {
            throw HeliosError.failedToStartClient(status.error.toString())
        } else {
            ip = localRpcIp
            port = localRpcPort
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

    /// Makes an EVM call at a specific block height
    /// - Parameters:
    ///   - callOptions: the call options of the call
    ///   - block: the block at which the call should be done against
    /// - Returns: the data of the call
    public func call(callOptions: EVMCallOptions, at block: EVMBlock = .latest) async throws -> Data {
        let response = await client.call(callOptions.asCallOpts(), block.asBlockTag())
        return try response.extractValue()
    }

    /// Sends a raw signed transaction
    /// - Parameter data: the raw signed transaction data
    /// - Returns: the transaction hash
    public func sendRawTransaction(_ data: Data) async throws -> String {
        let response = await client.send_raw_transaction(data.asRustVec())
        return try response.extractValue()
    }

    /// Estimates the gas a given transaction would consume
    /// - Parameter transaction: the transaction to estimate
    /// - Returns: the estimation of gas units that would be used
    public func estimateGas(for callOptions: EVMCallOptions) async throws -> UInt64 {
        let response = await client.estimate_gas(callOptions.asCallOpts())
        return try response.extractValue()
    }

    /// Returns the chain ID of the network.
    /// - Returns: the chain ID of the network
    public func chainId() async throws -> UInt64 {
        let response = await client.chain_id()
        return try response.extractValue()
    }

    /// Returns the current gas price
    /// - Returns: the gas price of the network in base 10 (decimal)
    public func getGasPrice() async throws -> String {
        let response = await client.get_gas_price()
        return try response.extractValue()
    }

    /// Returns the current priority fee
    /// - Returns: the priority fee of the network in base 10 (decimal)
    public func getPriorityFee() async throws -> String {
        let response = await client.get_priority_fee()
        return try response.extractValue()
    }

    /// Returns the current block height
    /// - Returns: the block height of the network
    public func getBlockNumber() async throws -> String {
        let response = await client.get_block_number()
        return try response.extractValue()
    }

    /// Gets the coinbase
    /// - Returns: the coinbase of the network in base 16 (hexadecimal)
    public func getCoinbase() async throws -> String {
        let response = await client.get_coinbase()
        return try response.extractValue()
    }

    /// Gets the balance of a given address.
    /// - Parameters:
    ///   - address: the address to check the balance
    ///   - block: the block at which we want to check address balance
    /// - Returns: the address' balance on base 10 format (decimal)
    public func getBalance(of address: String, at block: EVMBlock = .latest) async throws -> String {
        let response = await client.get_balance(address.intoRustString(), block.asBlockTag())
        return try response.extractValue()
    }

    /// Gets the nonce of a given address
    /// - Parameters:
    ///   - address: the address to check the nonce
    ///   - block: the block at which we want to check address nonce
    /// - Returns: the address' nonce
    public func getNonce(of address: String, at block: EVMBlock = .latest) async throws -> UInt64 {
        let response = await client.get_nonce(address.intoRustString(), block.asBlockTag())
        return try response.extractValue()
    }

    /// Gets the block details
    /// - Parameters:
    ///   - block: the block to fetch
    ///   - shouldIncludeTransactions: whether it should include the fully fledged transaction objects or just the transaction hashes.
    /// - Returns: the block details
    public func getBlock(_ block: EVMBlock, shouldIncludeTransactions: Bool = false) async throws -> EVMExecutionBlock {
        let response = await client.get_block_by_number(block.asBlockTag(), shouldIncludeTransactions)
        let block = try response.extractValue()
        guard let block = block else { throw HeliosError.executionBlockUnavailable }
        return block
    }

    /// Gets the block details given its hash
    /// - Parameters:
    ///   - hash: the block hash
    ///   - shouldIncludeTransactions: whether it should include the fully fledged transaction objects or just the transaction hashes.
    /// - Returns: the block details
    public func getBlock(byHash hash: String, shouldIncludeTransactions: Bool = false) async throws -> EVMExecutionBlock {
        let response = await client.get_block_by_hash(hash, shouldIncludeTransactions)
        let block = try response.extractValue()
        guard let block = block else { throw HeliosError.executionBlockUnavailable }
        return block
    }

    /// Gets the number of transactions that happened on a given block by its hash.
    /// - Parameter hash: the hash of the block
    /// - Returns: the number of transactions in the given block.
    public func getBlockTransactionCount(byHash hash: String) async throws -> UInt64 {
        let response = await client.get_block_transaction_count_by_hash(hash)
        return try response.extractValue()
    }

    /// Gets the number of transactions that happened on a given block.
    /// - Parameter block: the block to check for number of transactions.
    /// - Returns: the number of transactions in the given block.
    public func getBlockTransactionCount(at block: EVMBlock) async throws -> UInt64 {
        let response = await client.get_block_transaction_count_by_number(block.asBlockTag())
        return try response.extractValue()
    }

    /// Fetches a transacation receipt for a given hash
    /// - Parameter transactionHash: the hash of the transaction
    /// - Returns: the transaction receipt
    public func getTransactionReceipt(transactionHash: String) async throws -> EVMTransactionReceipt {
        let response = await client.get_transaction_receipt(transactionHash)
        let receipt = try response.extractValue()
        guard let receipt = receipt else { throw HeliosError.receiptUnavailable }
        return receipt
    }

    /// Gets the transaction details
    /// - Parameter hash: the transaction's hash
    /// - Returns: the transaction details
    public func getTransaction(_ hash: String) async throws -> EVMTransaction {
        let response = await client.get_transaction_by_hash(hash)
        let transaction = try response.extractValue()
        guard let transaction = transaction else { throw HeliosError.transactionUnavailable }
        return transaction
    }

    /// Gets the transaction details of a specific transaction inside a block at a given index
    /// - Parameters:
    ///   - blockHash: the block's hash
    ///   - index: the index of the transaction in the given block
    /// - Returns: the transaction details
    public func getTransaction(inBlock blockHash: String, atIndex index: UInt64) async throws -> EVMTransaction {
        let response = await client.get_transaction_by_block_hash_and_index(blockHash, index)
        let transaction = try response.extractValue()
        guard let transaction = transaction else { throw HeliosError.transactionUnavailable }
        return transaction
    }

    /// Get logs from a given block range, optionally filtering by address and topics.
    /// - Parameters:
    ///   - fromBlock: start of the block range (inclusive)
    ///   - toBlock: end of the block range (inclusive)
    ///   - address: optional address to filter the logs
    ///   - topics: optional topics to filter the logs
    /// - Returns: an array of logs
    public func getLogs(
        from fromBlock: EVMBlock? = nil,
        to toBlock: EVMBlock? = nil,
        address: String? = nil,
        topics: [String]? = nil
    ) async throws -> [EVMLog] {
        if let topics = topics,
           topics.count > 4 {
            throw HeliosError.tooManyTopics
        }

        let rustTopics = RustVec<RustString>()
        for topic in topics ?? [] {
            rustTopics.push(value: topic.intoRustString())
        }

        let response = await client.get_logs(
            LogFilter(
                block_option: .Range(from_block: fromBlock?.asBlockTag(), to_block: toBlock?.asBlockTag()),
                address: (address ?? "").intoRustString(),
                topics: rustTopics
            )
        )
        return try response.extractValue()
    }

    /// Get logs from a given block, optionally filtering by address and topics.
    /// - Parameters:
    ///   - blockHash: the hash of the block
    ///   - address: optional address to filter the logs
    ///   - topics: optional topics to filter the logs
    /// - Returns: an array of logs
    public func getLogs(
        at blockHash: String,
        address: String? = nil,
        topics: [String]? = nil
    ) async throws -> [EVMLog] {
        if let topics = topics,
           topics.count > 4 {
            throw HeliosError.tooManyTopics
        }

        let rustTopics = RustVec<RustString>()
        for topic in topics ?? [] {
            rustTopics.push(value: topic.intoRustString())
        }

        let response = await client.get_logs(
            LogFilter(
                block_option: .AtBlockHash(blockHash.intoRustString()),
                address: (address ?? "").intoRustString(),
                topics: rustTopics
            )
        )
        return try response.extractValue()
    }

    /// Returns the bytecode of a given smart contract address.
    /// - Parameters:
    ///   - address: the address of the smart contract.
    ///   - block: the block at which the query should be done on.
    /// - Returns: the bytecode data. If the address is not a smart contract it returns a 0 byte `Data`.
    public func getCode(for address: String, at block: EVMBlock = .latest) async throws -> Data {
        let response = await client.get_code(address.intoRustString(), block.asBlockTag())
        return try response.extractValue()
    }

    /// Returns the storage value of a given slot for a given address.
    /// - Parameters:
    ///   - address: the address
    ///   - slot: the storage slot
    ///   - block: the block at which the query should be done on.
    /// - Returns: the storage value on base 16 (hexadecimal)
    public func getStorage(for address: String, atSlot slot: String, block: EVMBlock = .latest) async throws -> String {
        let response = await client.get_storage_at(address.intoRustString(), slot.intoRustString(), block.asBlockTag())
        return try response.extractValue()
    }

    /// Gets the current sync status of the light client
    /// - Returns: the sync status
    public func syncing() async throws -> EVMSyncStatus {
        let response = await client.syncing()
        return try response.extractValue()
    }
    
    /// Suspends the current task until the light client is synced.
    ///
    /// This will keep polling the current syncing state with a time period of 100ms.
    public func waitUntilSynced() async throws {
        while case .syncing = try await syncing() {
            try await Task.sleep(nanoseconds: UInt64(10e8))
        }
    }

    /// Shuts down the client
    public func shutdown() async {
        await client.shutdown()
        ip = Defaults.ip
        port = Defaults.port
    }
}

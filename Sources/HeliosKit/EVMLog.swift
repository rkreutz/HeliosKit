import Foundation

public struct EVMLog: Equatable {
    public var address: String
    public var topics: [String]
    public var data: Data
    public var blockHash: String?
    public var blockNumber: UInt64?
    public var transactionHash: String?
    public var transactionIndex: UInt64?
    public var logIndex: String?
    public var transactionLogIndex: String?
    public var logType: String?
    public var removed: Bool?
}

extension EVMLog {
    init(from log: Log) {
        self.init(
            address: log.address.toString(),
            topics: log.topics.map { $0.as_str().toString() },
            data: Data(log.data),
            blockHash: log.block_hash.toString().nilIfEmpty(),
            blockNumber: log.block_number,
            transactionHash: log.transaction_hash.toString().nilIfEmpty(),
            transactionIndex: log.transaction_index,
            logIndex: log.log_index.toString().nilIfEmpty(),
            transactionLogIndex: log.transaction_log_index.toString().nilIfEmpty(),
            logType: log.log_type.toString().nilIfEmpty(),
            removed: log.removed
        )
    }
}

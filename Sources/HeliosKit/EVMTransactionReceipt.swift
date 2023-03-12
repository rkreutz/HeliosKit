import Foundation

public struct EVMTransactionReceipt: Equatable {
    public var transactionHash: String
    public var transactionIndex: UInt64
    public var blockHash: String?
    public var blockNumber: UInt64?
    public var from: String
    public var to: String?
    public var cumulativeGasUsed: String
    public var gasUsed: String?
    public var contractAddress: String?
    public var logs: [EVMLog]
    public var status: UInt64?
    public var root: String?
    public var logsBloom: Data
    public var transactionType: UInt64?
    public var effectiveGasPrice: String?
}

extension EVMTransactionReceipt {
    init(from receipt: TransactionReceipt) {
        self.init(
            transactionHash: receipt.transaction_hash.toString(),
            transactionIndex: receipt.transaction_index,
            blockHash: receipt.block_hash.toString().nilIfEmpty(),
            blockNumber: receipt.block_number,
            from: receipt.from.toString(),
            to: receipt.to.toString().nilIfEmpty(),
            cumulativeGasUsed: receipt.cumulative_gas_used.toString(),
            gasUsed: receipt.gas_used.toString().nilIfEmpty(),
            contractAddress: receipt.contract_address.toString().nilIfEmpty(),
            logs: receipt.logs.map(EVMLog.init(from:)),
            status: receipt.status,
            root: receipt.root.toString().nilIfEmpty(),
            logsBloom: Data(receipt.logs_bloom),
            transactionType: receipt.transaction_type,
            effectiveGasPrice: receipt.effective_gas_price.toString().nilIfEmpty()
        )
    }
}

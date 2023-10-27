import Foundation

public struct EVMExecutionBlock: Equatable {
    public enum Transactions: Equatable {
        case hashes([String])
        case full([EVMTransaction])
    }

    public var number: UInt64
    public var baseFeePerGas: String
    public var difficulty: String
    public var extraData: Data
    public var gasLimit: UInt64
    public var gasUsed: UInt64
    public var hash: String
    public var logsBloom: Data
    public var miner: String
    public var mixHash: String
    public var nonce: String
    public var parentHash: String
    public var receiptsRoot: String
    public var sha3Uncles: String
    public var size: UInt64
    public var stateRoot: String
    public var timestamp: UInt64
    public var totalDifficulty: UInt64
    public var transactions: Transactions
    public var transactionsRoot: String
    public var uncles: [String]
}

extension EVMExecutionBlock {
    init(from block: Block) {
        self.init(
            number: block.number,
            baseFeePerGas: block.base_fee_per_gas.toString(),
            difficulty: block.difficulty.toString(),
            extraData: Data(block.extra_data),
            gasLimit: block.gas_limit,
            gasUsed: block.gas_used,
            hash: block.hash.toString(),
            logsBloom: Data(block.logs_bloom),
            miner: block.miner.toString(),
            mixHash: block.mix_hash.toString(),
            nonce: block.nonce.toString(),
            parentHash: block.parent_hash.toString(),
            receiptsRoot: block.receipts_root.toString(),
            sha3Uncles: block.sha3_uncles.toString(),
            size: block.size,
            stateRoot: block.state_root.toString(),
            timestamp: block.timestamp,
            totalDifficulty: block.total_difficulty,
            transactions: Transactions(from: block.transactions),
            transactionsRoot: block.transactions_root.toString(),
            uncles: block.uncles.map { $0.as_str().toString() }
        )
    }
}

extension EVMExecutionBlock.Transactions {
    init(from transactions: Transactions) {
        switch transactions {
        case .Full(let transactions):
            self = .full(transactions.map(EVMTransaction.init(from:)))
            
        case .Hashes(let hashes):
            self = .hashes(hashes.map { $0.as_str().toString() })
        }
    }
}

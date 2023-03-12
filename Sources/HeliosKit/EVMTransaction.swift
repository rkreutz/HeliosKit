import Foundation

public struct EVMTransaction: Equatable {
    public var hash: String
    public var nonce: String
    public var blockHash: String?
    public var blockNumber: UInt64?
    public var transactionIndex: UInt64?
    public var from: String
    public var to: String?
    public var value: String
    public var gasPrice: String?
    public var gas: String
    public var input: Data
    public var v: String
    public var r: String
    public var s: String
}

extension EVMTransaction {
    init(from transaction: Transaction) {
        self.init(
            hash: transaction.hash.toString(),
            nonce: transaction.nonce.toString(),
            blockHash: transaction.block_hash.toString().nilIfEmpty(),
            blockNumber: transaction.block_number,
            transactionIndex: transaction.transaction_index,
            from: transaction.from.toString(),
            to: transaction.to.toString().nilIfEmpty(),
            value: transaction.value.toString(),
            gasPrice: transaction.gas_price.toString().nilIfEmpty(),
            gas: transaction.gas.toString(),
            input: Data(transaction.input),
            v: transaction.v.toString(),
            r: transaction.r.toString(),
            s: transaction.s.toString()
        )
    }
}

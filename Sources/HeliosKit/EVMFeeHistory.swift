import Foundation

public struct EVMFeeHistory {
    public var baseFeePerGas: [String]
    public var gasUsedRatio: [Double]
    public var oldestBlock: UInt64
    public var reward: [[String]]
}

extension EVMFeeHistory {
    init(from feeHistory: FeeHistory) {
        self.init(
            baseFeePerGas: feeHistory.base_fee_per_gas.map { $0.as_str().toString() },
            gasUsedRatio: Array(feeHistory.gas_used_ratio),
            oldestBlock: feeHistory.oldest_block,
            reward: feeHistory.reward.map { $0.as_str().toString().components(separatedBy: ",") }
        )
    }
}

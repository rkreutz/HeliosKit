import Foundation

protocol ValueExtractable {
    associatedtype Value

    func extractValue() throws -> Value
}

extension ResponseU64: ValueExtractable {
    func extractValue() throws -> UInt64 {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value
        }
    }
}

extension ResponseString: ValueExtractable {
    func extractValue() throws -> String {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.toString()
        }
    }
}

extension ResponseVec8: ValueExtractable {
    func extractValue() throws -> Data {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return Data(value)
        }
    }
}

extension ResponseVecLog: ValueExtractable {
    func extractValue() throws -> [EVMLog] {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMLog.init(from:))
        }
    }
}

extension ResponseTransactionReceipt: ValueExtractable {
    func extractValue() throws -> EVMTransactionReceipt? {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMTransactionReceipt.init(from:))
        }
    }
}

extension ResponseTransaction: ValueExtractable {
    func extractValue() throws -> EVMTransaction? {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMTransaction.init(from:))
        }
    }
}

extension ResponseBlock: ValueExtractable {
    func extractValue() throws -> EVMExecutionBlock? {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMExecutionBlock.init(from:))
        }
    }
}

extension ResponseSyncing: ValueExtractable {
    func extractValue() throws -> EVMSyncStatus {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            if let value = value {
                return .syncing(
                    EVMSyncStatus.Progress(
                        currentBlock: value.current_block,
                        highestBlock: value.highest_block,
                        startingBlock: value.starting_block
                    )
                )
            } else {
                return .synced
            }
        }
    }
}

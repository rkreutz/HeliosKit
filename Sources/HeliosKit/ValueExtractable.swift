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

extension ResponseHeader: ValueExtractable {
    func extractValue() throws -> EVMHeader? {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMHeader.init(from:))
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

extension ResponseExecutionBlock: ValueExtractable {
    func extractValue() throws -> EVMExecutionBlock? {
        if failed {
            throw HeliosError.failed(error.toString())
        } else {
            return value.map(EVMExecutionBlock.init(from:))
        }
    }
}

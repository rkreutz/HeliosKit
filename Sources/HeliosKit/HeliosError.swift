import Foundation

public enum HeliosError: LocalizedError {
    case failedToStartClient(String)
    case tooManyTopics
    case receiptUnavailable
    case executionBlockUnavailable
    case transactionUnavailable
    case headerUnavailable
    case feeHistoryUnavailable
    case failed(String)

    public var errorDescription: String? {
        switch self {
        case let .failedToStartClient(underlying):
            return "Failed to start client, underlying error message was: \(underlying)"
        case .tooManyTopics:
            return "Too many topics were provided."
        case .receiptUnavailable:
            return "Receipt unavailable."
        case .executionBlockUnavailable:
            return "Execution block unavailable."
        case .transactionUnavailable:
            return "Transaction unavailable."
        case .headerUnavailable:
            return "Header unavailable."
        case .feeHistoryUnavailable:
            return "Fee History unavailable."
        case let .failed(underlying):
            return underlying
        }
    }
}

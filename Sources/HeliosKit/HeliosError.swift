import Foundation

public enum HeliosError: LocalizedError {
    case failedToStartClient(String)

    public var errorDescription: String? {
        switch self {
        case let .failedToStartClient(underlying):
            return "Failed to start client, underlying error message was: \(underlying)"
        }
    }
}

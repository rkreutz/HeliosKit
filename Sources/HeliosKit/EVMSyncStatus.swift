import Foundation

public enum EVMSyncStatus: Equatable {
    
    public struct Progress: Equatable {
        public var currentBlock: UInt64
        public var highestBlock: UInt64
        public var startingBlock: UInt64
    }

    case synced
    case syncing(Progress)
}

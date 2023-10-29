import helios
enum BlockTag {
    case Latest
    case Finalized
    case Safe
    case Earliest
    case Pending
    case Number(UInt64)
}
extension BlockTag {
    func intoFfiRepr() -> __swift_bridge__$BlockTag {
        switch self {
        case BlockTag.Latest:
            return {var val = __swift_bridge__$BlockTag(); val.tag = __swift_bridge__$BlockTag$Latest; return val }()
        case BlockTag.Finalized:
            return {var val = __swift_bridge__$BlockTag(); val.tag = __swift_bridge__$BlockTag$Finalized; return val }()
        case BlockTag.Safe:
            return {var val = __swift_bridge__$BlockTag(); val.tag = __swift_bridge__$BlockTag$Safe; return val }()
        case BlockTag.Earliest:
            return {var val = __swift_bridge__$BlockTag(); val.tag = __swift_bridge__$BlockTag$Earliest; return val }()
        case BlockTag.Pending:
            return {var val = __swift_bridge__$BlockTag(); val.tag = __swift_bridge__$BlockTag$Pending; return val }()
        case BlockTag.Number(let _0):
            return __swift_bridge__$BlockTag(tag: __swift_bridge__$BlockTag$Number, payload: __swift_bridge__$BlockTagFields(Number: __swift_bridge__$BlockTag$FieldOfNumber(_0: _0)))
        }
    }
}
extension __swift_bridge__$BlockTag {
    func intoSwiftRepr() -> BlockTag {
        switch self.tag {
        case __swift_bridge__$BlockTag$Latest:
            return BlockTag.Latest
        case __swift_bridge__$BlockTag$Finalized:
            return BlockTag.Finalized
        case __swift_bridge__$BlockTag$Safe:
            return BlockTag.Safe
        case __swift_bridge__$BlockTag$Earliest:
            return BlockTag.Earliest
        case __swift_bridge__$BlockTag$Pending:
            return BlockTag.Pending
        case __swift_bridge__$BlockTag$Number:
            return BlockTag.Number(self.payload.Number._0)
        default:
            fatalError("Unreachable")
        }
    }
}
extension __swift_bridge__$Option$BlockTag {
    @inline(__always)
    func intoSwiftRepr() -> Optional<BlockTag> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }
    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<BlockTag>) -> __swift_bridge__$Option$BlockTag {
        if let v = val {
            return __swift_bridge__$Option$BlockTag(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$BlockTag(is_some: false, val: __swift_bridge__$BlockTag())
        }
    }
}
struct CallOpts {
    var from: RustString
    var to: RustString
    var gas: RustString
    var gas_price: RustString
    var value: RustString
    var data: RustString

    init(from: RustString,to: RustString,gas: RustString,gas_price: RustString,value: RustString,data: RustString) {
        self.from = from
        self.to = to
        self.gas = gas
        self.gas_price = gas_price
        self.value = value
        self.data = data
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$CallOpts {
        { let val = self; return __swift_bridge__$CallOpts(from: { let rustString = val.from.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), to: { let rustString = val.to.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), gas: { let rustString = val.gas.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), gas_price: { let rustString = val.gas_price.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), value: { let rustString = val.value.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), data: { let rustString = val.data.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$CallOpts {
    @inline(__always)
    func intoSwiftRepr() -> CallOpts {
        { let val = self; return CallOpts(from: RustString(ptr: val.from), to: RustString(ptr: val.to), gas: RustString(ptr: val.gas), gas_price: RustString(ptr: val.gas_price), value: RustString(ptr: val.value), data: RustString(ptr: val.data)); }()
    }
}
extension __swift_bridge__$Option$CallOpts {
    @inline(__always)
    func intoSwiftRepr() -> Optional<CallOpts> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<CallOpts>) -> __swift_bridge__$Option$CallOpts {
        if let v = val {
            return __swift_bridge__$Option$CallOpts(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$CallOpts(is_some: false, val: __swift_bridge__$CallOpts())
        }
    }
}
enum HeliosNetwork {
    case MAINNET
    case GOERLI
    case SEPOLIA
}
extension HeliosNetwork {
    func intoFfiRepr() -> __swift_bridge__$HeliosNetwork {
        switch self {
        case HeliosNetwork.MAINNET:
            return __swift_bridge__$HeliosNetwork(tag: __swift_bridge__$HeliosNetwork$MAINNET)
        case HeliosNetwork.GOERLI:
            return __swift_bridge__$HeliosNetwork(tag: __swift_bridge__$HeliosNetwork$GOERLI)
        case HeliosNetwork.SEPOLIA:
            return __swift_bridge__$HeliosNetwork(tag: __swift_bridge__$HeliosNetwork$SEPOLIA)
        }
    }
}
extension __swift_bridge__$HeliosNetwork {
    func intoSwiftRepr() -> HeliosNetwork {
        switch self.tag {
        case __swift_bridge__$HeliosNetwork$MAINNET:
            return HeliosNetwork.MAINNET
        case __swift_bridge__$HeliosNetwork$GOERLI:
            return HeliosNetwork.GOERLI
        case __swift_bridge__$HeliosNetwork$SEPOLIA:
            return HeliosNetwork.SEPOLIA
        default:
            fatalError("Unreachable")
        }
    }
}
extension __swift_bridge__$Option$HeliosNetwork {
    @inline(__always)
    func intoSwiftRepr() -> Optional<HeliosNetwork> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }
    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<HeliosNetwork>) -> __swift_bridge__$Option$HeliosNetwork {
        if let v = val {
            return __swift_bridge__$Option$HeliosNetwork(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$HeliosNetwork(is_some: false, val: __swift_bridge__$HeliosNetwork())
        }
    }
}
extension HeliosNetwork: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_HeliosNetwork$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_HeliosNetwork$drop(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_HeliosNetwork$push(vecPtr, value.intoFfiRepr())
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let maybeEnum = __swift_bridge__$Vec_HeliosNetwork$pop(vecPtr)
        return maybeEnum.intoSwiftRepr()
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeEnum = __swift_bridge__$Vec_HeliosNetwork$get(vecPtr, index)
        return maybeEnum.intoSwiftRepr()
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeEnum = __swift_bridge__$Vec_HeliosNetwork$get_mut(vecPtr, index)
        return maybeEnum.intoSwiftRepr()
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_HeliosNetwork$len(vecPtr)
    }
}
struct StartUpState {
    var started: Bool
    var error: RustString

    init(started: Bool,error: RustString) {
        self.started = started
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$StartUpState {
        { let val = self; return __swift_bridge__$StartUpState(started: val.started, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$StartUpState {
    @inline(__always)
    func intoSwiftRepr() -> StartUpState {
        { let val = self; return StartUpState(started: val.started, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$StartUpState {
    @inline(__always)
    func intoSwiftRepr() -> Optional<StartUpState> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<StartUpState>) -> __swift_bridge__$Option$StartUpState {
        if let v = val {
            return __swift_bridge__$Option$StartUpState(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$StartUpState(is_some: false, val: __swift_bridge__$StartUpState())
        }
    }
}
enum FilterBlockOption {
    case Range(from_block: Optional<BlockTag>, to_block: Optional<BlockTag>)
    case AtBlockHash(RustString)
}
extension FilterBlockOption {
    func intoFfiRepr() -> __swift_bridge__$FilterBlockOption {
        switch self {
        case FilterBlockOption.Range(let from_block, let to_block):
            return __swift_bridge__$FilterBlockOption(tag: __swift_bridge__$FilterBlockOption$Range, payload: __swift_bridge__$FilterBlockOptionFields(Range: __swift_bridge__$FilterBlockOption$FieldOfRange(from_block: __swift_bridge__$Option$BlockTag.fromSwiftRepr(from_block), to_block: __swift_bridge__$Option$BlockTag.fromSwiftRepr(to_block))))
        case FilterBlockOption.AtBlockHash(let _0):
            return __swift_bridge__$FilterBlockOption(tag: __swift_bridge__$FilterBlockOption$AtBlockHash, payload: __swift_bridge__$FilterBlockOptionFields(AtBlockHash: __swift_bridge__$FilterBlockOption$FieldOfAtBlockHash(_0: { let rustString = _0.intoRustString(); rustString.isOwned = false; return rustString.ptr }())))
        }
    }
}
extension __swift_bridge__$FilterBlockOption {
    func intoSwiftRepr() -> FilterBlockOption {
        switch self.tag {
        case __swift_bridge__$FilterBlockOption$Range:
            return FilterBlockOption.Range(from_block: self.payload.Range.from_block.intoSwiftRepr(), to_block: self.payload.Range.to_block.intoSwiftRepr())
        case __swift_bridge__$FilterBlockOption$AtBlockHash:
            return FilterBlockOption.AtBlockHash(RustString(ptr: self.payload.AtBlockHash._0))
        default:
            fatalError("Unreachable")
        }
    }
}
extension __swift_bridge__$Option$FilterBlockOption {
    @inline(__always)
    func intoSwiftRepr() -> Optional<FilterBlockOption> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }
    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<FilterBlockOption>) -> __swift_bridge__$Option$FilterBlockOption {
        if let v = val {
            return __swift_bridge__$Option$FilterBlockOption(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$FilterBlockOption(is_some: false, val: __swift_bridge__$FilterBlockOption())
        }
    }
}
struct LogFilter {
    var block_option: FilterBlockOption
    var address: RustString
    var topics: RustVec<RustString>

    init(block_option: FilterBlockOption,address: RustString,topics: RustVec<RustString>) {
        self.block_option = block_option
        self.address = address
        self.topics = topics
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$LogFilter {
        { let val = self; return __swift_bridge__$LogFilter(block_option: val.block_option.intoFfiRepr(), address: { let rustString = val.address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), topics: { let val = val.topics; val.isOwned = false; return val.ptr }()); }()
    }
}
extension __swift_bridge__$LogFilter {
    @inline(__always)
    func intoSwiftRepr() -> LogFilter {
        { let val = self; return LogFilter(block_option: val.block_option.intoSwiftRepr(), address: RustString(ptr: val.address), topics: RustVec(ptr: val.topics)); }()
    }
}
extension __swift_bridge__$Option$LogFilter {
    @inline(__always)
    func intoSwiftRepr() -> Optional<LogFilter> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<LogFilter>) -> __swift_bridge__$Option$LogFilter {
        if let v = val {
            return __swift_bridge__$Option$LogFilter(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$LogFilter(is_some: false, val: __swift_bridge__$LogFilter())
        }
    }
}
struct Log {
    var address: RustString
    var topics: RustVec<RustString>
    var data: RustVec<UInt8>
    var block_hash: RustString
    var block_number: Optional<UInt64>
    var transaction_hash: RustString
    var transaction_index: Optional<UInt64>
    var log_index: RustString
    var transaction_log_index: RustString
    var log_type: RustString
    var removed: Optional<Bool>

    init(address: RustString,topics: RustVec<RustString>,data: RustVec<UInt8>,block_hash: RustString,block_number: Optional<UInt64>,transaction_hash: RustString,transaction_index: Optional<UInt64>,log_index: RustString,transaction_log_index: RustString,log_type: RustString,removed: Optional<Bool>) {
        self.address = address
        self.topics = topics
        self.data = data
        self.block_hash = block_hash
        self.block_number = block_number
        self.transaction_hash = transaction_hash
        self.transaction_index = transaction_index
        self.log_index = log_index
        self.transaction_log_index = transaction_log_index
        self.log_type = log_type
        self.removed = removed
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$Log {
        { let val = self; return __swift_bridge__$Log(address: { let rustString = val.address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), topics: { let val = val.topics; val.isOwned = false; return val.ptr }(), data: { let val = val.data; val.isOwned = false; return val.ptr }(), block_hash: { let rustString = val.block_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block_number: val.block_number.intoFfiRepr(), transaction_hash: { let rustString = val.transaction_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), transaction_index: val.transaction_index.intoFfiRepr(), log_index: { let rustString = val.log_index.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), transaction_log_index: { let rustString = val.transaction_log_index.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), log_type: { let rustString = val.log_type.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), removed: val.removed.intoFfiRepr()); }()
    }
}
extension __swift_bridge__$Log {
    @inline(__always)
    func intoSwiftRepr() -> Log {
        { let val = self; return Log(address: RustString(ptr: val.address), topics: RustVec(ptr: val.topics), data: RustVec(ptr: val.data), block_hash: RustString(ptr: val.block_hash), block_number: val.block_number.intoSwiftRepr(), transaction_hash: RustString(ptr: val.transaction_hash), transaction_index: val.transaction_index.intoSwiftRepr(), log_index: RustString(ptr: val.log_index), transaction_log_index: RustString(ptr: val.transaction_log_index), log_type: RustString(ptr: val.log_type), removed: val.removed.intoSwiftRepr()); }()
    }
}
extension __swift_bridge__$Option$Log {
    @inline(__always)
    func intoSwiftRepr() -> Optional<Log> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<Log>) -> __swift_bridge__$Option$Log {
        if let v = val {
            return __swift_bridge__$Option$Log(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$Log(is_some: false, val: __swift_bridge__$Log())
        }
    }
}
extension Log: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_Log$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_Log$drop(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_Log$push(vecPtr, value.intoFfiRepr())
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Log$pop(vecPtr)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Log$get(vecPtr, index)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Log$get_mut(vecPtr, index)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_Log$len(vecPtr)
    }
}
struct TransactionReceipt {
    var transaction_hash: RustString
    var transaction_index: UInt64
    var block_hash: RustString
    var block_number: Optional<UInt64>
    var from: RustString
    var to: RustString
    var cumulative_gas_used: RustString
    var gas_used: RustString
    var contract_address: RustString
    var logs: RustVec<Log>
    var status: Optional<UInt64>
    var root: RustString
    var logs_bloom: RustVec<UInt8>
    var transaction_type: Optional<UInt64>
    var effective_gas_price: RustString

    init(transaction_hash: RustString,transaction_index: UInt64,block_hash: RustString,block_number: Optional<UInt64>,from: RustString,to: RustString,cumulative_gas_used: RustString,gas_used: RustString,contract_address: RustString,logs: RustVec<Log>,status: Optional<UInt64>,root: RustString,logs_bloom: RustVec<UInt8>,transaction_type: Optional<UInt64>,effective_gas_price: RustString) {
        self.transaction_hash = transaction_hash
        self.transaction_index = transaction_index
        self.block_hash = block_hash
        self.block_number = block_number
        self.from = from
        self.to = to
        self.cumulative_gas_used = cumulative_gas_used
        self.gas_used = gas_used
        self.contract_address = contract_address
        self.logs = logs
        self.status = status
        self.root = root
        self.logs_bloom = logs_bloom
        self.transaction_type = transaction_type
        self.effective_gas_price = effective_gas_price
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$TransactionReceipt {
        { let val = self; return __swift_bridge__$TransactionReceipt(transaction_hash: { let rustString = val.transaction_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), transaction_index: val.transaction_index, block_hash: { let rustString = val.block_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block_number: val.block_number.intoFfiRepr(), from: { let rustString = val.from.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), to: { let rustString = val.to.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), cumulative_gas_used: { let rustString = val.cumulative_gas_used.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), gas_used: { let rustString = val.gas_used.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), contract_address: { let rustString = val.contract_address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), logs: { let val = val.logs; val.isOwned = false; return val.ptr }(), status: val.status.intoFfiRepr(), root: { let rustString = val.root.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), logs_bloom: { let val = val.logs_bloom; val.isOwned = false; return val.ptr }(), transaction_type: val.transaction_type.intoFfiRepr(), effective_gas_price: { let rustString = val.effective_gas_price.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$TransactionReceipt {
    @inline(__always)
    func intoSwiftRepr() -> TransactionReceipt {
        { let val = self; return TransactionReceipt(transaction_hash: RustString(ptr: val.transaction_hash), transaction_index: val.transaction_index, block_hash: RustString(ptr: val.block_hash), block_number: val.block_number.intoSwiftRepr(), from: RustString(ptr: val.from), to: RustString(ptr: val.to), cumulative_gas_used: RustString(ptr: val.cumulative_gas_used), gas_used: RustString(ptr: val.gas_used), contract_address: RustString(ptr: val.contract_address), logs: RustVec(ptr: val.logs), status: val.status.intoSwiftRepr(), root: RustString(ptr: val.root), logs_bloom: RustVec(ptr: val.logs_bloom), transaction_type: val.transaction_type.intoSwiftRepr(), effective_gas_price: RustString(ptr: val.effective_gas_price)); }()
    }
}
extension __swift_bridge__$Option$TransactionReceipt {
    @inline(__always)
    func intoSwiftRepr() -> Optional<TransactionReceipt> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<TransactionReceipt>) -> __swift_bridge__$Option$TransactionReceipt {
        if let v = val {
            return __swift_bridge__$Option$TransactionReceipt(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$TransactionReceipt(is_some: false, val: __swift_bridge__$TransactionReceipt())
        }
    }
}
struct Transaction {
    var hash: RustString
    var nonce: RustString
    var block_hash: RustString
    var block_number: Optional<UInt64>
    var transaction_index: Optional<UInt64>
    var from: RustString
    var to: RustString
    var value: RustString
    var gas_price: RustString
    var gas: RustString
    var input: RustVec<UInt8>
    var v: RustString
    var r: RustString
    var s: RustString

    init(hash: RustString,nonce: RustString,block_hash: RustString,block_number: Optional<UInt64>,transaction_index: Optional<UInt64>,from: RustString,to: RustString,value: RustString,gas_price: RustString,gas: RustString,input: RustVec<UInt8>,v: RustString,r: RustString,s: RustString) {
        self.hash = hash
        self.nonce = nonce
        self.block_hash = block_hash
        self.block_number = block_number
        self.transaction_index = transaction_index
        self.from = from
        self.to = to
        self.value = value
        self.gas_price = gas_price
        self.gas = gas
        self.input = input
        self.v = v
        self.r = r
        self.s = s
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$Transaction {
        { let val = self; return __swift_bridge__$Transaction(hash: { let rustString = val.hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), nonce: { let rustString = val.nonce.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block_hash: { let rustString = val.block_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block_number: val.block_number.intoFfiRepr(), transaction_index: val.transaction_index.intoFfiRepr(), from: { let rustString = val.from.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), to: { let rustString = val.to.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), value: { let rustString = val.value.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), gas_price: { let rustString = val.gas_price.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), gas: { let rustString = val.gas.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), input: { let val = val.input; val.isOwned = false; return val.ptr }(), v: { let rustString = val.v.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), r: { let rustString = val.r.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), s: { let rustString = val.s.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$Transaction {
    @inline(__always)
    func intoSwiftRepr() -> Transaction {
        { let val = self; return Transaction(hash: RustString(ptr: val.hash), nonce: RustString(ptr: val.nonce), block_hash: RustString(ptr: val.block_hash), block_number: val.block_number.intoSwiftRepr(), transaction_index: val.transaction_index.intoSwiftRepr(), from: RustString(ptr: val.from), to: RustString(ptr: val.to), value: RustString(ptr: val.value), gas_price: RustString(ptr: val.gas_price), gas: RustString(ptr: val.gas), input: RustVec(ptr: val.input), v: RustString(ptr: val.v), r: RustString(ptr: val.r), s: RustString(ptr: val.s)); }()
    }
}
extension __swift_bridge__$Option$Transaction {
    @inline(__always)
    func intoSwiftRepr() -> Optional<Transaction> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<Transaction>) -> __swift_bridge__$Option$Transaction {
        if let v = val {
            return __swift_bridge__$Option$Transaction(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$Transaction(is_some: false, val: __swift_bridge__$Transaction())
        }
    }
}
extension Transaction: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_Transaction$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_Transaction$drop(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_Transaction$push(vecPtr, value.intoFfiRepr())
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Transaction$pop(vecPtr)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Transaction$get(vecPtr, index)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let maybeStruct = __swift_bridge__$Vec_Transaction$get_mut(vecPtr, index)
        return maybeStruct.intoSwiftRepr()
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_Transaction$len(vecPtr)
    }
}
enum Transactions {
    case Hashes(RustVec<RustString>)
    case Full(RustVec<Transaction>)
}
extension Transactions {
    func intoFfiRepr() -> __swift_bridge__$Transactions {
        switch self {
        case Transactions.Hashes(let _0):
            return __swift_bridge__$Transactions(tag: __swift_bridge__$Transactions$Hashes, payload: __swift_bridge__$TransactionsFields(Hashes: __swift_bridge__$Transactions$FieldOfHashes(_0: { let val = _0; val.isOwned = false; return val.ptr }())))
        case Transactions.Full(let _0):
            return __swift_bridge__$Transactions(tag: __swift_bridge__$Transactions$Full, payload: __swift_bridge__$TransactionsFields(Full: __swift_bridge__$Transactions$FieldOfFull(_0: { let val = _0; val.isOwned = false; return val.ptr }())))
        }
    }
}
extension __swift_bridge__$Transactions {
    func intoSwiftRepr() -> Transactions {
        switch self.tag {
        case __swift_bridge__$Transactions$Hashes:
            return Transactions.Hashes(RustVec(ptr: self.payload.Hashes._0))
        case __swift_bridge__$Transactions$Full:
            return Transactions.Full(RustVec(ptr: self.payload.Full._0))
        default:
            fatalError("Unreachable")
        }
    }
}
extension __swift_bridge__$Option$Transactions {
    @inline(__always)
    func intoSwiftRepr() -> Optional<Transactions> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }
    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<Transactions>) -> __swift_bridge__$Option$Transactions {
        if let v = val {
            return __swift_bridge__$Option$Transactions(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$Transactions(is_some: false, val: __swift_bridge__$Transactions())
        }
    }
}
struct Block {
    var number: UInt64
    var base_fee_per_gas: RustString
    var difficulty: RustString
    var extra_data: RustVec<UInt8>
    var gas_limit: UInt64
    var gas_used: UInt64
    var hash: RustString
    var logs_bloom: RustVec<UInt8>
    var miner: RustString
    var mix_hash: RustString
    var nonce: RustString
    var parent_hash: RustString
    var receipts_root: RustString
    var sha3_uncles: RustString
    var size: UInt64
    var state_root: RustString
    var timestamp: UInt64
    var total_difficulty: UInt64
    var transactions: Transactions
    var transactions_root: RustString
    var uncles: RustVec<RustString>

    init(number: UInt64,base_fee_per_gas: RustString,difficulty: RustString,extra_data: RustVec<UInt8>,gas_limit: UInt64,gas_used: UInt64,hash: RustString,logs_bloom: RustVec<UInt8>,miner: RustString,mix_hash: RustString,nonce: RustString,parent_hash: RustString,receipts_root: RustString,sha3_uncles: RustString,size: UInt64,state_root: RustString,timestamp: UInt64,total_difficulty: UInt64,transactions: Transactions,transactions_root: RustString,uncles: RustVec<RustString>) {
        self.number = number
        self.base_fee_per_gas = base_fee_per_gas
        self.difficulty = difficulty
        self.extra_data = extra_data
        self.gas_limit = gas_limit
        self.gas_used = gas_used
        self.hash = hash
        self.logs_bloom = logs_bloom
        self.miner = miner
        self.mix_hash = mix_hash
        self.nonce = nonce
        self.parent_hash = parent_hash
        self.receipts_root = receipts_root
        self.sha3_uncles = sha3_uncles
        self.size = size
        self.state_root = state_root
        self.timestamp = timestamp
        self.total_difficulty = total_difficulty
        self.transactions = transactions
        self.transactions_root = transactions_root
        self.uncles = uncles
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$Block {
        { let val = self; return __swift_bridge__$Block(number: val.number, base_fee_per_gas: { let rustString = val.base_fee_per_gas.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), difficulty: { let rustString = val.difficulty.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), extra_data: { let val = val.extra_data; val.isOwned = false; return val.ptr }(), gas_limit: val.gas_limit, gas_used: val.gas_used, hash: { let rustString = val.hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), logs_bloom: { let val = val.logs_bloom; val.isOwned = false; return val.ptr }(), miner: { let rustString = val.miner.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), mix_hash: { let rustString = val.mix_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), nonce: { let rustString = val.nonce.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), parent_hash: { let rustString = val.parent_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), receipts_root: { let rustString = val.receipts_root.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), sha3_uncles: { let rustString = val.sha3_uncles.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), size: val.size, state_root: { let rustString = val.state_root.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), timestamp: val.timestamp, total_difficulty: val.total_difficulty, transactions: val.transactions.intoFfiRepr(), transactions_root: { let rustString = val.transactions_root.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), uncles: { let val = val.uncles; val.isOwned = false; return val.ptr }()); }()
    }
}
extension __swift_bridge__$Block {
    @inline(__always)
    func intoSwiftRepr() -> Block {
        { let val = self; return Block(number: val.number, base_fee_per_gas: RustString(ptr: val.base_fee_per_gas), difficulty: RustString(ptr: val.difficulty), extra_data: RustVec(ptr: val.extra_data), gas_limit: val.gas_limit, gas_used: val.gas_used, hash: RustString(ptr: val.hash), logs_bloom: RustVec(ptr: val.logs_bloom), miner: RustString(ptr: val.miner), mix_hash: RustString(ptr: val.mix_hash), nonce: RustString(ptr: val.nonce), parent_hash: RustString(ptr: val.parent_hash), receipts_root: RustString(ptr: val.receipts_root), sha3_uncles: RustString(ptr: val.sha3_uncles), size: val.size, state_root: RustString(ptr: val.state_root), timestamp: val.timestamp, total_difficulty: val.total_difficulty, transactions: val.transactions.intoSwiftRepr(), transactions_root: RustString(ptr: val.transactions_root), uncles: RustVec(ptr: val.uncles)); }()
    }
}
extension __swift_bridge__$Option$Block {
    @inline(__always)
    func intoSwiftRepr() -> Optional<Block> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<Block>) -> __swift_bridge__$Option$Block {
        if let v = val {
            return __swift_bridge__$Option$Block(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$Block(is_some: false, val: __swift_bridge__$Block())
        }
    }
}
struct SyncingStatus {
    var current_block: UInt64
    var highest_block: UInt64
    var starting_block: UInt64

    init(current_block: UInt64,highest_block: UInt64,starting_block: UInt64) {
        self.current_block = current_block
        self.highest_block = highest_block
        self.starting_block = starting_block
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$SyncingStatus {
        { let val = self; return __swift_bridge__$SyncingStatus(current_block: val.current_block, highest_block: val.highest_block, starting_block: val.starting_block); }()
    }
}
extension __swift_bridge__$SyncingStatus {
    @inline(__always)
    func intoSwiftRepr() -> SyncingStatus {
        { let val = self; return SyncingStatus(current_block: val.current_block, highest_block: val.highest_block, starting_block: val.starting_block); }()
    }
}
extension __swift_bridge__$Option$SyncingStatus {
    @inline(__always)
    func intoSwiftRepr() -> Optional<SyncingStatus> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<SyncingStatus>) -> __swift_bridge__$Option$SyncingStatus {
        if let v = val {
            return __swift_bridge__$Option$SyncingStatus(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$SyncingStatus(is_some: false, val: __swift_bridge__$SyncingStatus())
        }
    }
}
struct ResponseU64 {
    var value: UInt64
    var failed: Bool
    var error: RustString

    init(value: UInt64,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseU64 {
        { let val = self; return __swift_bridge__$ResponseU64(value: val.value, failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseU64 {
    @inline(__always)
    func intoSwiftRepr() -> ResponseU64 {
        { let val = self; return ResponseU64(value: val.value, failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseU64 {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseU64> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseU64>) -> __swift_bridge__$Option$ResponseU64 {
        if let v = val {
            return __swift_bridge__$Option$ResponseU64(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseU64(is_some: false, val: __swift_bridge__$ResponseU64())
        }
    }
}
struct ResponseString {
    var value: RustString
    var failed: Bool
    var error: RustString

    init(value: RustString,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseString {
        { let val = self; return __swift_bridge__$ResponseString(value: { let rustString = val.value.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseString {
    @inline(__always)
    func intoSwiftRepr() -> ResponseString {
        { let val = self; return ResponseString(value: RustString(ptr: val.value), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseString {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseString> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseString>) -> __swift_bridge__$Option$ResponseString {
        if let v = val {
            return __swift_bridge__$Option$ResponseString(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseString(is_some: false, val: __swift_bridge__$ResponseString())
        }
    }
}
struct ResponseVec8 {
    var value: RustVec<UInt8>
    var failed: Bool
    var error: RustString

    init(value: RustVec<UInt8>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseVec8 {
        { let val = self; return __swift_bridge__$ResponseVec8(value: { let val = val.value; val.isOwned = false; return val.ptr }(), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseVec8 {
    @inline(__always)
    func intoSwiftRepr() -> ResponseVec8 {
        { let val = self; return ResponseVec8(value: RustVec(ptr: val.value), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseVec8 {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseVec8> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseVec8>) -> __swift_bridge__$Option$ResponseVec8 {
        if let v = val {
            return __swift_bridge__$Option$ResponseVec8(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseVec8(is_some: false, val: __swift_bridge__$ResponseVec8())
        }
    }
}
struct ResponseVecLog {
    var value: RustVec<Log>
    var failed: Bool
    var error: RustString

    init(value: RustVec<Log>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseVecLog {
        { let val = self; return __swift_bridge__$ResponseVecLog(value: { let val = val.value; val.isOwned = false; return val.ptr }(), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseVecLog {
    @inline(__always)
    func intoSwiftRepr() -> ResponseVecLog {
        { let val = self; return ResponseVecLog(value: RustVec(ptr: val.value), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseVecLog {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseVecLog> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseVecLog>) -> __swift_bridge__$Option$ResponseVecLog {
        if let v = val {
            return __swift_bridge__$Option$ResponseVecLog(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseVecLog(is_some: false, val: __swift_bridge__$ResponseVecLog())
        }
    }
}
struct ResponseTransactionReceipt {
    var value: Optional<TransactionReceipt>
    var failed: Bool
    var error: RustString

    init(value: Optional<TransactionReceipt>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseTransactionReceipt {
        { let val = self; return __swift_bridge__$ResponseTransactionReceipt(value: __swift_bridge__$Option$TransactionReceipt.fromSwiftRepr(val.value), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseTransactionReceipt {
    @inline(__always)
    func intoSwiftRepr() -> ResponseTransactionReceipt {
        { let val = self; return ResponseTransactionReceipt(value: val.value.intoSwiftRepr(), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseTransactionReceipt {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseTransactionReceipt> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseTransactionReceipt>) -> __swift_bridge__$Option$ResponseTransactionReceipt {
        if let v = val {
            return __swift_bridge__$Option$ResponseTransactionReceipt(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseTransactionReceipt(is_some: false, val: __swift_bridge__$ResponseTransactionReceipt())
        }
    }
}
struct ResponseTransaction {
    var value: Optional<Transaction>
    var failed: Bool
    var error: RustString

    init(value: Optional<Transaction>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseTransaction {
        { let val = self; return __swift_bridge__$ResponseTransaction(value: __swift_bridge__$Option$Transaction.fromSwiftRepr(val.value), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseTransaction {
    @inline(__always)
    func intoSwiftRepr() -> ResponseTransaction {
        { let val = self; return ResponseTransaction(value: val.value.intoSwiftRepr(), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseTransaction {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseTransaction> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseTransaction>) -> __swift_bridge__$Option$ResponseTransaction {
        if let v = val {
            return __swift_bridge__$Option$ResponseTransaction(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseTransaction(is_some: false, val: __swift_bridge__$ResponseTransaction())
        }
    }
}
struct ResponseBlock {
    var value: Optional<Block>
    var failed: Bool
    var error: RustString

    init(value: Optional<Block>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseBlock {
        { let val = self; return __swift_bridge__$ResponseBlock(value: __swift_bridge__$Option$Block.fromSwiftRepr(val.value), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseBlock {
    @inline(__always)
    func intoSwiftRepr() -> ResponseBlock {
        { let val = self; return ResponseBlock(value: val.value.intoSwiftRepr(), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseBlock {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseBlock> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseBlock>) -> __swift_bridge__$Option$ResponseBlock {
        if let v = val {
            return __swift_bridge__$Option$ResponseBlock(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseBlock(is_some: false, val: __swift_bridge__$ResponseBlock())
        }
    }
}
struct ResponseSyncing {
    var value: Optional<SyncingStatus>
    var failed: Bool
    var error: RustString

    init(value: Optional<SyncingStatus>,failed: Bool,error: RustString) {
        self.value = value
        self.failed = failed
        self.error = error
    }

    @inline(__always)
    func intoFfiRepr() -> __swift_bridge__$ResponseSyncing {
        { let val = self; return __swift_bridge__$ResponseSyncing(value: __swift_bridge__$Option$SyncingStatus.fromSwiftRepr(val.value), failed: val.failed, error: { let rustString = val.error.intoRustString(); rustString.isOwned = false; return rustString.ptr }()); }()
    }
}
extension __swift_bridge__$ResponseSyncing {
    @inline(__always)
    func intoSwiftRepr() -> ResponseSyncing {
        { let val = self; return ResponseSyncing(value: val.value.intoSwiftRepr(), failed: val.failed, error: RustString(ptr: val.error)); }()
    }
}
extension __swift_bridge__$Option$ResponseSyncing {
    @inline(__always)
    func intoSwiftRepr() -> Optional<ResponseSyncing> {
        if self.is_some {
            return self.val.intoSwiftRepr()
        } else {
            return nil
        }
    }

    @inline(__always)
    static func fromSwiftRepr(_ val: Optional<ResponseSyncing>) -> __swift_bridge__$Option$ResponseSyncing {
        if let v = val {
            return __swift_bridge__$Option$ResponseSyncing(is_some: true, val: v.intoFfiRepr())
        } else {
            return __swift_bridge__$Option$ResponseSyncing(is_some: false, val: __swift_bridge__$ResponseSyncing())
        }
    }
}

class HeliosClient: HeliosClientRefMut {
    var isOwned: Bool = true

    override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$HeliosClient$_free(ptr)
        }
    }
}
extension HeliosClient {
    convenience init() {
        self.init(ptr: __swift_bridge__$HeliosClient$new())
    }
}
class HeliosClientRefMut: HeliosClientRef {
    override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
extension HeliosClientRefMut {
    func start<GenericIntoRustString: IntoRustString>(_ untrusted_rpc_url: GenericIntoRustString, _ consensus_rpc_url: GenericIntoRustString, _ checkpoint: Optional<GenericIntoRustString>, _ rpc_ip: GenericIntoRustString, _ rpc_port: UInt16, _ network: HeliosNetwork, _ data_dir: Optional<GenericIntoRustString>) async -> StartUpState {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$StartUpState) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$start>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<StartUpState, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$start(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$start(wrapperPtr, onComplete, ptr, { let rustString = untrusted_rpc_url.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = consensus_rpc_url.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { if let rustString = optionalStringIntoRustString(checkpoint) { rustString.isOwned = false; return rustString.ptr } else { return nil } }(), { let rustString = rpc_ip.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), rpc_port, network.intoFfiRepr(), { if let rustString = optionalStringIntoRustString(data_dir) { rustString.isOwned = false; return rustString.ptr } else { return nil } }())
        })
    }
    class CbWrapper$HeliosClient$start {
        var cb: (Result<StartUpState, Never>) -> ()

        init(cb: @escaping (Result<StartUpState, Never>) -> ()) {
            self.cb = cb
        }
    }

    func shutdown() async {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$shutdown>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<(), Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$shutdown(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$shutdown(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$shutdown {
        var cb: (Result<(), Never>) -> ()

        init(cb: @escaping (Result<(), Never>) -> ()) {
            self.cb = cb
        }
    }
}
class HeliosClientRef {
    var ptr: UnsafeMutableRawPointer

    init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension HeliosClientRef {
    func call(_ opts: CallOpts, _ block: BlockTag) async -> ResponseVec8 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseVec8) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$call>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseVec8, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$call(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$call(wrapperPtr, onComplete, ptr, opts.intoFfiRepr(), block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$call {
        var cb: (Result<ResponseVec8, Never>) -> ()

        init(cb: @escaping (Result<ResponseVec8, Never>) -> ()) {
            self.cb = cb
        }
    }

    func send_raw_transaction(_ bytes: RustVec<UInt8>) async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$send_raw_transaction>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$send_raw_transaction(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$send_raw_transaction(wrapperPtr, onComplete, ptr, { let val = bytes; val.isOwned = false; return val.ptr }())
        })
    }
    class CbWrapper$HeliosClient$send_raw_transaction {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func estimate_gas(_ opts: CallOpts) async -> ResponseU64 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseU64) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$estimate_gas>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseU64, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$estimate_gas(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$estimate_gas(wrapperPtr, onComplete, ptr, opts.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$estimate_gas {
        var cb: (Result<ResponseU64, Never>) -> ()

        init(cb: @escaping (Result<ResponseU64, Never>) -> ()) {
            self.cb = cb
        }
    }

    func chain_id() async -> ResponseU64 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseU64) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$chain_id>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseU64, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$chain_id(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$chain_id(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$chain_id {
        var cb: (Result<ResponseU64, Never>) -> ()

        init(cb: @escaping (Result<ResponseU64, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_gas_price() async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_gas_price>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_gas_price(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_gas_price(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$get_gas_price {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_priority_fee() async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_priority_fee>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_priority_fee(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_priority_fee(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$get_priority_fee {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_block_number() async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_block_number>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_block_number(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_block_number(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$get_block_number {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_coinbase() async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_coinbase>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_coinbase(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_coinbase(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$get_coinbase {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_balance<GenericIntoRustString: IntoRustString>(_ address: GenericIntoRustString, _ block: BlockTag) async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_balance>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_balance(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_balance(wrapperPtr, onComplete, ptr, { let rustString = address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_balance {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_nonce<GenericIntoRustString: IntoRustString>(_ address: GenericIntoRustString, _ block: BlockTag) async -> ResponseU64 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseU64) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_nonce>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseU64, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_nonce(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_nonce(wrapperPtr, onComplete, ptr, { let rustString = address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_nonce {
        var cb: (Result<ResponseU64, Never>) -> ()

        init(cb: @escaping (Result<ResponseU64, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_block_by_number(_ block: BlockTag, _ full_tx: Bool) async -> ResponseBlock {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseBlock) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_block_by_number>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseBlock, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_block_by_number(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_block_by_number(wrapperPtr, onComplete, ptr, block.intoFfiRepr(), full_tx)
        })
    }
    class CbWrapper$HeliosClient$get_block_by_number {
        var cb: (Result<ResponseBlock, Never>) -> ()

        init(cb: @escaping (Result<ResponseBlock, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_block_by_hash<GenericIntoRustString: IntoRustString>(_ hash: GenericIntoRustString, _ full_tx: Bool) async -> ResponseBlock {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseBlock) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_block_by_hash>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseBlock, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_block_by_hash(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_block_by_hash(wrapperPtr, onComplete, ptr, { let rustString = hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), full_tx)
        })
    }
    class CbWrapper$HeliosClient$get_block_by_hash {
        var cb: (Result<ResponseBlock, Never>) -> ()

        init(cb: @escaping (Result<ResponseBlock, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_block_transaction_count_by_hash<GenericIntoRustString: IntoRustString>(_ hash: GenericIntoRustString) async -> ResponseU64 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseU64) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_block_transaction_count_by_hash>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseU64, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_block_transaction_count_by_hash(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_block_transaction_count_by_hash(wrapperPtr, onComplete, ptr, { let rustString = hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
        })
    }
    class CbWrapper$HeliosClient$get_block_transaction_count_by_hash {
        var cb: (Result<ResponseU64, Never>) -> ()

        init(cb: @escaping (Result<ResponseU64, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_block_transaction_count_by_number(_ block: BlockTag) async -> ResponseU64 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseU64) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_block_transaction_count_by_number>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseU64, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_block_transaction_count_by_number(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_block_transaction_count_by_number(wrapperPtr, onComplete, ptr, block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_block_transaction_count_by_number {
        var cb: (Result<ResponseU64, Never>) -> ()

        init(cb: @escaping (Result<ResponseU64, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_transaction_receipt<GenericIntoRustString: IntoRustString>(_ tx_hash: GenericIntoRustString) async -> ResponseTransactionReceipt {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseTransactionReceipt) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_transaction_receipt>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseTransactionReceipt, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_transaction_receipt(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_transaction_receipt(wrapperPtr, onComplete, ptr, { let rustString = tx_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
        })
    }
    class CbWrapper$HeliosClient$get_transaction_receipt {
        var cb: (Result<ResponseTransactionReceipt, Never>) -> ()

        init(cb: @escaping (Result<ResponseTransactionReceipt, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_transaction_by_hash<GenericIntoRustString: IntoRustString>(_ tx_hash: GenericIntoRustString) async -> ResponseTransaction {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseTransaction) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_transaction_by_hash>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseTransaction, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_transaction_by_hash(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_transaction_by_hash(wrapperPtr, onComplete, ptr, { let rustString = tx_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
        })
    }
    class CbWrapper$HeliosClient$get_transaction_by_hash {
        var cb: (Result<ResponseTransaction, Never>) -> ()

        init(cb: @escaping (Result<ResponseTransaction, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_transaction_by_block_hash_and_index<GenericIntoRustString: IntoRustString>(_ block_hash: GenericIntoRustString, _ index: UInt64) async -> ResponseTransaction {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseTransaction) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_transaction_by_block_hash_and_index>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseTransaction, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_transaction_by_block_hash_and_index(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_transaction_by_block_hash_and_index(wrapperPtr, onComplete, ptr, { let rustString = block_hash.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), index)
        })
    }
    class CbWrapper$HeliosClient$get_transaction_by_block_hash_and_index {
        var cb: (Result<ResponseTransaction, Never>) -> ()

        init(cb: @escaping (Result<ResponseTransaction, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_logs(_ filter: LogFilter) async -> ResponseVecLog {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseVecLog) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_logs>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseVecLog, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_logs(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_logs(wrapperPtr, onComplete, ptr, filter.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_logs {
        var cb: (Result<ResponseVecLog, Never>) -> ()

        init(cb: @escaping (Result<ResponseVecLog, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_code<GenericIntoRustString: IntoRustString>(_ address: GenericIntoRustString, _ block: BlockTag) async -> ResponseVec8 {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseVec8) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_code>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseVec8, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_code(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_code(wrapperPtr, onComplete, ptr, { let rustString = address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_code {
        var cb: (Result<ResponseVec8, Never>) -> ()

        init(cb: @escaping (Result<ResponseVec8, Never>) -> ()) {
            self.cb = cb
        }
    }

    func get_storage_at<GenericIntoRustString: IntoRustString>(_ address: GenericIntoRustString, _ slot: GenericIntoRustString, _ block: BlockTag) async -> ResponseString {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseString) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$get_storage_at>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseString, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$get_storage_at(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$get_storage_at(wrapperPtr, onComplete, ptr, { let rustString = address.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = slot.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), block.intoFfiRepr())
        })
    }
    class CbWrapper$HeliosClient$get_storage_at {
        var cb: (Result<ResponseString, Never>) -> ()

        init(cb: @escaping (Result<ResponseString, Never>) -> ()) {
            self.cb = cb
        }
    }

    func syncing() async -> ResponseSyncing {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?, rustFnRetVal: __swift_bridge__$ResponseSyncing) {
            let wrapper = Unmanaged<CbWrapper$HeliosClient$syncing>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(rustFnRetVal.intoSwiftRepr()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<ResponseSyncing, Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$HeliosClient$syncing(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$HeliosClient$syncing(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$HeliosClient$syncing {
        var cb: (Result<ResponseSyncing, Never>) -> ()

        init(cb: @escaping (Result<ResponseSyncing, Never>) -> ()) {
            self.cb = cb
        }
    }
}
extension HeliosClient: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_HeliosClient$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_HeliosClient$drop(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: HeliosClient) {
        __swift_bridge__$Vec_HeliosClient$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_HeliosClient$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (HeliosClient(ptr: pointer!) as! Self)
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<HeliosClientRef> {
        let pointer = __swift_bridge__$Vec_HeliosClient$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return HeliosClientRef(ptr: pointer!)
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<HeliosClientRefMut> {
        let pointer = __swift_bridge__$Vec_HeliosClient$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return HeliosClientRefMut(ptr: pointer!)
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_HeliosClient$len(vecPtr)
    }
}




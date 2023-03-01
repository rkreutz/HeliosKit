import helios
enum HeliosNetwork {
    case MAINNET
    case GOERLI
}
extension HeliosNetwork {
    func intoFfiRepr() -> __swift_bridge__$HeliosNetwork {
        switch self {
            case HeliosNetwork.MAINNET:
                return __swift_bridge__$HeliosNetwork(tag: __swift_bridge__$HeliosNetwork$MAINNET)
            case HeliosNetwork.GOERLI:
                return __swift_bridge__$HeliosNetwork(tag: __swift_bridge__$HeliosNetwork$GOERLI)
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
    func start<GenericIntoRustString: IntoRustString>(_ untrusted_rpc_url: GenericIntoRustString, _ consensus_rpc_url: GenericIntoRustString, _ checkpoint: Optional<GenericIntoRustString>, _ rpc_port: UInt16, _ network: HeliosNetwork) async -> StartUpState {
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

            __swift_bridge__$HeliosClient$start(wrapperPtr, onComplete, ptr, { let rustString = untrusted_rpc_url.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { let rustString = consensus_rpc_url.intoRustString(); rustString.isOwned = false; return rustString.ptr }(), { if let rustString = optionalStringIntoRustString(checkpoint) { rustString.isOwned = false; return rustString.ptr } else { return nil } }(), rpc_port, network.intoFfiRepr())
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




import helios
import Foundation

extension RustString {
    func toString() -> String {
        let str = self.as_str()
        let string = str.toString()

        return string
    }
}

extension RustStr {
    func toBufferPointer() -> UnsafeBufferPointer<UInt8> {
        let bytes = UnsafeBufferPointer(start: self.start, count: Int(self.len))
        return bytes
    }

    func toString() -> String {
        let bytes = self.toBufferPointer()
        return String(bytes: bytes, encoding: .utf8)!
    }
}
extension RustStr: Identifiable {
    public var id: String {
        self.toString()
    }
}
extension RustStr: Equatable {
    public static func == (lhs: RustStr, rhs: RustStr) -> Bool {
        return __swift_bridge__$RustStr$partial_eq(lhs, rhs);
    }
}

protocol IntoRustString {
    func intoRustString() -> RustString;
}

protocol ToRustStr {
    func toRustStr<T> (_ withUnsafeRustStr: (RustStr) -> T) -> T;
}

extension String: IntoRustString {
    func intoRustString() -> RustString {
        // TODO: When passing an owned Swift std String to Rust we've being wasteful here in that
        //  we're creating a RustString (which involves Boxing a Rust std::string::String)
        //  only to unbox it back into a String once it gets to the Rust side.
        //
        //  A better approach would be to pass a RustStr to the Rust side and then have Rust
        //  call `.to_string()` on the RustStr.
        RustString(self)
    }
}

extension RustString: IntoRustString {
    func intoRustString() -> RustString {
        self
    }
}

/// If the String is Some:
///   Safely get a scoped pointer to the String and then call the callback with a RustStr
///   that uses that pointer.
///
/// If the String is None:
///   Call the callback with a RustStr that has a null pointer.
///   The Rust side will know to treat this as `None`.
func optionalStringIntoRustString<S: IntoRustString>(_ string: Optional<S>) -> RustString? {
    if let val = string {
        return val.intoRustString()
    } else {
        return nil
    }
}

extension String: ToRustStr {
    /// Safely get a scoped pointer to the String and then call the callback with a RustStr
    /// that uses that pointer.
    func toRustStr<T> (_ withUnsafeRustStr: (RustStr) -> T) -> T {
        return self.utf8CString.withUnsafeBufferPointer({ bufferPtr in
            let rustStr = RustStr(
                start: UnsafeMutableRawPointer(mutating: bufferPtr.baseAddress!).assumingMemoryBound(to: UInt8.self),
                // Subtract 1 because of the null termination character at the end
                len: UInt(bufferPtr.count - 1)
            )
            return withUnsafeRustStr(rustStr)
        })
    }
}

extension RustStr: ToRustStr {
    func toRustStr<T> (_ withUnsafeRustStr: (RustStr) -> T) -> T {
        return withUnsafeRustStr(self)
    }
}

func optionalRustStrToRustStr<S: ToRustStr, T>(_ str: Optional<S>, _ withUnsafeRustStr: (RustStr) -> T) -> T {
    if let val = str {
        return val.toRustStr(withUnsafeRustStr)
    } else {
        return withUnsafeRustStr(RustStr(start: nil, len: 0))
    }
}
class RustVec<T: Vectorizable> {
    var ptr: UnsafeMutableRawPointer
    var isOwned: Bool = true

    init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }

    init() {
        ptr = T.vecOfSelfNew()
        isOwned = true
    }

    func push (value: T) {
        T.vecOfSelfPush(vecPtr: ptr, value: value)
    }

    func pop () -> Optional<T> {
        T.vecOfSelfPop(vecPtr: ptr)
    }

    func get(index: UInt) -> Optional<T.SelfRef> {
        T.vecOfSelfGet(vecPtr: ptr, index: index)
    }

    /// Rust returns a UInt, but we cast to an Int because many Swift APIs such as
    /// `ForEach(0..rustVec.len())` expect Int.
    func len() -> Int {
        Int(T.vecOfSelfLen(vecPtr: ptr))
    }

    deinit {
        if isOwned {
            T.vecOfSelfFree(vecPtr: ptr)
        }
    }
}

extension RustVec: Sequence {
    func makeIterator() -> RustVecIterator<T> {
        return RustVecIterator(self)
    }
}

struct RustVecIterator<T: Vectorizable>: IteratorProtocol {
    var rustVec: RustVec<T>
    var index: UInt = 0

    init (_ rustVec: RustVec<T>) {
        self.rustVec = rustVec
    }

    mutating func next() -> T.SelfRef? {
        let val = rustVec.get(index: index)
        index += 1
        return val
    }
}

extension RustVec: Collection {
    typealias Index = Int

    func index(after i: Int) -> Int {
        i + 1
    }

    subscript(position: Int) -> T.SelfRef {
        self.get(index: UInt(position))!
    }

    var startIndex: Int {
        0
    }

    var endIndex: Int {
        self.len()
    }
}

extension RustVec: RandomAccessCollection {}

extension UnsafeBufferPointer {
    func toFfiSlice () -> __private__FfiSlice {
        __private__FfiSlice(start: UnsafeMutablePointer(mutating: self.baseAddress), len: UInt(self.count))
    }
}

protocol Vectorizable {
    associatedtype SelfRef
    associatedtype SelfRefMut

    static func vecOfSelfNew() -> UnsafeMutableRawPointer;

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer)

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self)

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self>

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<SelfRef>

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<SelfRefMut>

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt
}

extension UInt8: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_u8$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_u8$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_u8$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u8$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u8$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u8$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_u8$len(vecPtr)
    }
}

extension UInt16: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_u16$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_u16$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_u16$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u16$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u16$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u16$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_u16$len(vecPtr)
    }
}

extension UInt32: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_u32$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_u32$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_u32$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u32$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u32$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u32$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_u32$len(vecPtr)
    }
}

extension UInt64: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_u64$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_u64$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_u64$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u64$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u64$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_u64$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_u64$len(vecPtr)
    }
}

extension UInt: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_usize$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_usize$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_usize$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_usize$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_usize$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_usize$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_usize$len(vecPtr)
    }
}

extension Int8: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_i8$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_i8$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_i8$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i8$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i8$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i8$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_i8$len(vecPtr)
    }
}

extension Int16: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_i16$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_i16$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_i16$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i16$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i16$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i16$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_i16$len(vecPtr)
    }
}

extension Int32: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_i32$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_i32$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_i32$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i32$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i32$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i32$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_i32$len(vecPtr)
    }
}

extension Int64: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_i64$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_i64$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_i64$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i64$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i64$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_i64$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_i64$len(vecPtr)
    }
}

extension Int: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_isize$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_isize$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_isize$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_isize$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_isize$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_isize$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_isize$len(vecPtr)
    }
}

extension Bool: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_bool$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_bool$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_bool$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_bool$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_bool$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_bool$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_bool$len(vecPtr)
    }
}

extension Float: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_f32$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_f32$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_f32$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f32$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f32$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f32$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_f32$len(vecPtr)
    }
}

extension Double: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_f64$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_f64$_free(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: Self) {
        __swift_bridge__$Vec_f64$push(vecPtr, value)
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f64$pop(vecPtr)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f64$get(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<Self> {
        let val = __swift_bridge__$Vec_f64$get_mut(vecPtr, index)
        if val.is_some {
            return val.val
        } else {
            return nil
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_f64$len(vecPtr)
    }
}

protocol SwiftBridgeGenericFreer {
    func rust_free();
}

protocol SwiftBridgeGenericCopyTypeFfiRepr {}

class RustString: RustStringRefMut {
    var isOwned: Bool = true

    override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$RustString$_free(ptr)
        }
    }
}
extension RustString {
    convenience init() {
        self.init(ptr: __swift_bridge__$RustString$new())
    }

    convenience init<GenericToRustStr: ToRustStr>(_ str: GenericToRustStr) {
        self.init(ptr: str.toRustStr({ strAsRustStr in
            __swift_bridge__$RustString$new_with_str(strAsRustStr)
        }))
    }
}
class RustStringRefMut: RustStringRef {
    override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
class RustStringRef {
    var ptr: UnsafeMutableRawPointer

    init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
extension RustStringRef {
    func len() -> UInt {
        __swift_bridge__$RustString$len(ptr)
    }

    func as_str() -> RustStr {
        __swift_bridge__$RustString$as_str(ptr)
    }

    func trim() -> RustStr {
        __swift_bridge__$RustString$trim(ptr)
    }
}
extension RustString: Vectorizable {
    static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_RustString$new()
    }

    static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_RustString$drop(vecPtr)
    }

    static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: RustString) {
        __swift_bridge__$Vec_RustString$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Optional<Self> {
        let pointer = __swift_bridge__$Vec_RustString$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (RustString(ptr: pointer!) as! Self)
        }
    }

    static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RustStringRef> {
        let pointer = __swift_bridge__$Vec_RustString$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RustStringRef(ptr: pointer!)
        }
    }

    static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> Optional<RustStringRefMut> {
        let pointer = __swift_bridge__$Vec_RustString$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return RustStringRefMut(ptr: pointer!)
        }
    }

    static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_RustString$len(vecPtr)
    }
}

class __private__RustFnOnceCallbackNoArgsNoRet {
    var ptr: UnsafeMutableRawPointer
    var called = false

    init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }

    deinit {
        if !called {
            __swift_bridge__$free_boxed_fn_once_no_args_no_return(ptr)
        }
    }

    func call() {
        if called {
            fatalError("Cannot call a Rust FnOnce function twice")
        }
        called = true
        return __swift_bridge__$call_boxed_fn_once_no_args_no_return(ptr)
    }
}


enum RustResult<T, E> {
    case Ok(T)
    case Err(E)
}

extension RustResult {
    func ok() -> T? {
        switch self {
        case .Ok(let ok):
            return ok
        case .Err(_):
            return nil
        }
    }

    func err() -> E? {
        switch self {
        case .Ok(_):
            return nil
        case .Err(let err):
            return err
        }
    }

    func toResult() -> Result<T, E>
    where E: Error {
        switch self {
        case .Ok(let ok):
            return .success(ok)
        case .Err(let err):
            return .failure(err)
        }
    }
}


extension __private__OptionU8 {
    func intoSwiftRepr() -> Optional<UInt8> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<UInt8>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == UInt8 {
    func intoFfiRepr() -> __private__OptionU8 {
        __private__OptionU8(self)
    }
}

extension __private__OptionI8 {
    func intoSwiftRepr() -> Optional<Int8> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Int8>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == Int8 {
    func intoFfiRepr() -> __private__OptionI8 {
        __private__OptionI8(self)
    }
}

extension __private__OptionU16 {
    func intoSwiftRepr() -> Optional<UInt16> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<UInt16>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == UInt16 {
    func intoFfiRepr() -> __private__OptionU16 {
        __private__OptionU16(self)
    }
}

extension __private__OptionI16 {
    func intoSwiftRepr() -> Optional<Int16> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Int16>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == Int16 {
    func intoFfiRepr() -> __private__OptionI16 {
        __private__OptionI16(self)
    }
}

extension __private__OptionU32 {
    func intoSwiftRepr() -> Optional<UInt32> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<UInt32>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == UInt32 {
    func intoFfiRepr() -> __private__OptionU32 {
        __private__OptionU32(self)
    }
}

extension __private__OptionI32 {
    func intoSwiftRepr() -> Optional<Int32> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Int32>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == Int32 {
    func intoFfiRepr() -> __private__OptionI32 {
        __private__OptionI32(self)
    }
}

extension __private__OptionU64 {
    func intoSwiftRepr() -> Optional<UInt64> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<UInt64>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == UInt64 {
    func intoFfiRepr() -> __private__OptionU64 {
        __private__OptionU64(self)
    }
}

extension __private__OptionI64 {
    func intoSwiftRepr() -> Optional<Int64> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Int64>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == Int64 {
    func intoFfiRepr() -> __private__OptionI64 {
        __private__OptionI64(self)
    }
}

extension __private__OptionUsize {
    func intoSwiftRepr() -> Optional<UInt> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<UInt>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == UInt {
    func intoFfiRepr() -> __private__OptionUsize {
        __private__OptionUsize(self)
    }
}

extension __private__OptionIsize {
    func intoSwiftRepr() -> Optional<Int> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Int>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123, is_some: false)
        }
    }
}
extension Optional where Wrapped == Int {
    func intoFfiRepr() -> __private__OptionIsize {
        __private__OptionIsize(self)
    }
}

extension __private__OptionF32 {
    func intoSwiftRepr() -> Optional<Float> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Float>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123.4, is_some: false)
        }
    }
}
extension Optional where Wrapped == Float {
    func intoFfiRepr() -> __private__OptionF32 {
        __private__OptionF32(self)
    }
}

extension __private__OptionF64 {
    func intoSwiftRepr() -> Optional<Double> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Double>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: 123.4, is_some: false)
        }
    }
}
extension Optional where Wrapped == Double {
    func intoFfiRepr() -> __private__OptionF64 {
        __private__OptionF64(self)
    }
}

extension __private__OptionBool {
    func intoSwiftRepr() -> Optional<Bool> {
        if self.is_some {
            return self.val
        } else {
            return nil
        }
    }

    init(_ val: Optional<Bool>) {
        if let val = val {
            self = Self(val: val, is_some: true)
        } else {
            self = Self(val: false, is_some: false)
        }
    }
}
extension Optional where Wrapped == Bool {
    func intoFfiRepr() -> __private__OptionBool {
        __private__OptionBool(self)
    }
}

// Playground - noun: a place where people can play

import Foundation

typealias Byte = UInt8

protocol GenericIntegerType: IntegerType {
    init(_ v: Int)
    init(_ v: UInt)
    init(_ v: Int8)
    init(_ v: UInt8)
    init(_ v: Int16)
    init(_ v: UInt16)
    init(_ v: Int32)
    init(_ v: UInt32)
    init(_ v: Int64)
    init(_ v: UInt64)
}

protocol GenericSignedIntegerBitPattern {
    init(bitPattern: UIntMax)
    init(truncatingBitPattern: IntMax)
}

protocol GenericUnsignedIntegerBitPattern {
    init(truncatingBitPattern: UIntMax)
}

extension Int:GenericIntegerType, GenericSignedIntegerBitPattern  {
    init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt(truncatingBitPattern: bitPattern))
    }
}
extension UInt:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int8:GenericIntegerType, GenericSignedIntegerBitPattern {
    init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt8(truncatingBitPattern: bitPattern))
    }
}
extension UInt8:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int16:GenericIntegerType, GenericSignedIntegerBitPattern {
    init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt16(truncatingBitPattern: bitPattern))
    }
}
extension UInt16:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int32:GenericIntegerType, GenericSignedIntegerBitPattern {
    init(bitPattern: UIntMax) {
        self.init(bitPattern: UInt32(truncatingBitPattern: bitPattern))
    }
}
extension UInt32:GenericIntegerType, GenericUnsignedIntegerBitPattern {}
extension Int64:GenericIntegerType, GenericSignedIntegerBitPattern {
    // init(bitPattern: UInt64) already defined
    
    init(truncatingBitPattern: IntMax) {
        self.init(truncatingBitPattern)
    }
}
extension UInt64:GenericIntegerType, GenericUnsignedIntegerBitPattern {
    // init(bitPattern: Int64) already defined
    
    init(truncatingBitPattern: UIntMax) {
        self.init(truncatingBitPattern)
    }
}

func toByteArray<T>(var value: T) -> [Byte] {
    return withUnsafePointer(&value) {
        Array(UnsafeBufferPointer(start: UnsafePointer<Byte>($0), count: sizeof(T)))
    }
}

func integerWithBytes<T: GenericIntegerType where T: UnsignedIntegerType, T: GenericUnsignedIntegerBitPattern>(bytes:[UInt8]) -> T? {
    if (bytes.count < sizeof(T)) {
        return nil
    }
    
    let maxBytes = sizeof(T)
    var i:UIntMax = 0
    for (var j = 0; j < maxBytes; j++) {
        i = i | T(bytes[j]).toUIntMax() << UIntMax(j * 8)
    }
    return T(truncatingBitPattern: i)
}

func integerWithBytes<T: GenericIntegerType where T: SignedIntegerType, T:  GenericSignedIntegerBitPattern>(bytes:[UInt8]) -> T? {
    if (bytes.count < sizeof(T)) {
        return nil
    }
    
    let maxBytes = sizeof(T)
    var i:IntMax = 0
    for (var j = 0; j < maxBytes; j++) {
        i = i | T(bitPattern: UIntMax(bytes[j].toUIntMax())).toIntMax() << (j * 8).toIntMax()
    }
    return T(truncatingBitPattern: i)
}


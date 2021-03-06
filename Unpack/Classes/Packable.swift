//
//  Packable.swift
//  Pods-Unpack_Tests
//
//  Created by Oren F on 15/04/2018.
//

import Foundation

/// Global function for ease of converting `Packable` to `Data`
public func pack(_ object: Packable) throws -> Data {
    return try object.pack()
}

/// Global function for ease of converting `Packable` to `Any` (i.e JSON / [JSON])
public func json(_ object: Packable) throws -> Any {
    return try object.json()
}

/// A protocol extending `Encodable`, allowing it to easily convert to `Data` or `JSON`
public protocol Packable: Encodable {
    
    static var encoder: JSONEncoder { get }
    
    func pack() throws -> Data
    func pack(using encoder: JSONEncoder) throws -> Data

    func json() throws -> Any
    func json(using encoder: JSONEncoder) throws -> Any
    func json(using encoder: JSONEncoder, options: JSONSerialization.ReadingOptions) throws -> Any
}

public extension Packable {
    
    static var encoder: JSONEncoder {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .secondsSince1970
        enc.dataEncodingStrategy = .base64
        enc.keyEncodingStrategy = .convertToSnakeCase
        return enc
    }
    
    func pack() throws -> Data {
        return try pack(using: Self.encoder)
    }
    
    func pack(using encoder: JSONEncoder) throws -> Data {
        return try encoder.encode(self)
    }

    func json() throws -> Any {
        return try json(using: Self.encoder)
    }
    
    func json(using encoder: JSONEncoder) throws -> Any {
        return try json(using: encoder, options: JSONSerialization.unpackReadingOptions)
    }
    
    func json(using encoder: JSONEncoder, options: JSONSerialization.ReadingOptions) throws -> Any {
        let data = try pack(using: encoder)
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}

//
//  Aliases.swift
//  MatrixSwiftBase
//
//  Shared typealiases so downstream apps stop redefining the same shapes.
//  Keep this list small and curated — only aliases that are load-bearing
//  across apps. A typealias that only saves five characters and obscures
//  meaning does not belong here.
//

import Foundation

/// A decoded JSON object.
public typealias JSONDictionary = [String: Any]

/// A decoded JSON array.
public typealias JSONArray = [Any]

/// An async result callback carrying either a value or an error.
public typealias Completion<T> = (Result<T, Error>) -> Void

/// A no-argument, no-return callback.
public typealias VoidCompletion = () -> Void

/// A raw byte buffer.
public typealias Bytes = [UInt8]

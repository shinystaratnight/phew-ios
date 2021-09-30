//
//  UnknownType.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

enum UnknownType<S: Codable, I: Codable>: Codable {
    
    case string(S)
    case integer(I)
    
    var value: String? {
        switch self {
        case .integer(let val):
            return "\(val)"
        case .string(let val):
            return val as? String
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(S.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(I.self) {
            self = .integer(x)
            return
        }
        throw DecodingError.typeMismatch(UnknownType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

/*
 // F:- First Data Type
 // S:- Secound Data Type
 // R:- Result Data Type
 enum UnknownType<F: Codable, S: Codable, R: Codable>: Codable {
 
 case integer(S)
 case string(F)
 
 var desc: R? {
 switch self {
 case .integer(let val):
 return val as? R
 case .string(let val):
 return val as? R
 }
 }
 
 init(from decoder: Decoder) throws {
 let container = try decoder.singleValueContainer()
 if let x = try? container.decode(S.self) {
 self = .integer(x)
 return
 }
 if let x = try? container.decode(F.self) {
 self = .string(x)
 return
 }
 throw DecodingError.typeMismatch(UnknownType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
 }
 
 func encode(to encoder: Encoder) throws {
 var container = encoder.singleValueContainer()
 switch self {
 case .integer(let x):
 try container.encode(x)
 case .string(let x):
 try container.encode(x)
 }
 }
 }
 
 struct datadata: Codable {
 var data: UnknownType<String, Int, Int>?
 }
 
 class ayhaga {
 init() {
 var data: datadata!
 if let val = data.data?.desc {
 print(val)
 }
 }
 }
 */


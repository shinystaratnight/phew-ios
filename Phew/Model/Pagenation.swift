//
//  Pagenation.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/21/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//


import Foundation
protocol PagenationProtocol {
    var isLoading: Bool {get set}
    var lastPage: Int? {get set}
    var current: Int {get set}
}

class Pagenation {
    
    static func canPagenat(isLoading:Bool,lastPage: Int?, current: Int,index: Int, count: Int) -> Bool {
        guard !isLoading else{return false}
        guard let lastPage = lastPage else{return false}
        guard lastPage > current else{return false}
        guard index == count - 2 else{return false}
        return true
    }

}

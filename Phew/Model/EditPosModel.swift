//
//  EidtPosModel.swift
//  Phew
//
//  Created by Ahmed Elesawy on 1/19/21.
//  Copyright © 2021 Mohamed Akl. All rights reserved.
//

import Foundation
enum postEditEnum {
    case delete
    case edit
    case findaly
    case policy
}

struct EditPostModel {
    let name: String
    let imageName: String
    let type: postEditEnum
}

//
//  RequestExtension.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("====================******************===================")
        debugPrint(self)
        debugPrint("====================******************===================")
        #endif
        return self
    }
}

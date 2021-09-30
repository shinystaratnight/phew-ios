//
//  String+.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "Hello From String Extension")
    }

    var isInt: Bool {
        return Int(self) != nil
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: trimmedString)
    }
    
    var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isResponseValid: Bool {
        return self == "success"
    }
    
    func subString(index: Int) -> String{
        let value = self.prefix(index)
        return String(value)
    }
    var removeNewLine: String {
        let value =  String(self.filter { !" \n\t\r".contains($0) })
        return value
    }
}

extension Double {
    var string: String {
        return "\(self)"
    }
}

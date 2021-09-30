//
//  Date+.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var tooString : String {
        get{
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH🇲🇲ss"
            let myString = formatter.string(from: self)
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en")
            // again convert your date to string
            let myStringafd = formatter.string(from: yourDate!)
            return myStringafd
        }
    }
}

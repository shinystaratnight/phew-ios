//
//  Validiator.swift
//  Phew
//
//  Created by Mohamed Akl on 8/24/20.
//  Copyright © 2020 Mohamed Akl. All rights reserved.
//

import Foundation

protocol ValidatorError: Error {
    var associatedMessage: String { get }
}

class Validator {
    
    static var isUserLoggedIn: Bool {
        return AuthService.userData?.token?.accessToken != nil
    }
    
    @discardableResult
    static func validateMail(with mail: String?) throws -> String {
        if let mail = mail {
            if mail.isEmpty {
                throw UserAuthentcationError.emptyMail
            } else if !mail.trimmedString.isEmail {
                throw UserAuthentcationError.invalidMail
            } else {
                return mail.trimmedString
            }
        } else {
            throw UserAuthentcationError.emptyMail
        }
    }
    
    @discardableResult
    static func validateName(with name: String?) throws -> String {
        if let name = name {
            if name.isEmpty {
                throw UserAuthentcationError.emptyName
            } else if name.count < 6 {
                throw UserAuthentcationError.tooShortName
            } else {
                return name
            }
        } else {
            throw UserAuthentcationError.emptyName
        }
    }
    
    @discardableResult
    static func validatePhone(with phone: String?) throws -> String {
        if let phone = phone {
            if phone.isEmpty {
                throw UserAuthentcationError.emptyPhone
            } else if !phone.isInt {
                if phone.replacingOccurrences(of: "+", with: "").isInt {
                    return phone
                } else {
                    throw UserAuthentcationError.invalidPhone
                }
            } else if phone.count < 6 {
                throw UserAuthentcationError.tooShortPhone
            } else {
                return phone
            }
        } else {
            throw UserAuthentcationError.emptyPhone
        }
    }
    
    @discardableResult
    static func validate(with value: String?, decription: String, count: Int = 1) throws -> String {
        if let value = value {
            if value.isEmpty {
                throw UserAuthentcationError.emptyField(decription: decription)
            } else if value.count < count {
                throw UserAuthentcationError.tooShortField(decription: decription, count: count)
            } else {
                return value
            }
        } else {
            throw UserAuthentcationError.emptyField(decription: decription)
        }
    }
    
    @discardableResult
    static func validate<T: Any>(with value: T?, decription: String) throws -> T {
        if let value = value {
            return value
        } else {
            throw UserAuthentcationError.emptyField(decription: decription)
        }
    }
    
    @discardableResult
    static func validate<T: Any>(with value: [T]?, decription: String, count: Int = 1) throws -> [T] {
        guard let value = value, !value.isEmpty else {
            throw UserAuthentcationError.emptyField(decription: decription)
        }
        guard value.count >= count else {
            throw UserAuthentcationError.tooShortField(decription: decription, count: count)
        }
        return value
    }
    
    @discardableResult
    static func validatePassword(with password: String?, minCount: Int = 6) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw UserAuthentcationError.emptyPass
        }
        guard password.count >= minCount else {
            throw UserAuthentcationError.tooShortPass(count: minCount)
        }
        return password
    }
    
    @discardableResult
    static func validateTwoPasswords(password: String?, confirmPassword: String?, minCount: Int = 6) throws  -> String {
        guard let password = password, !password.isEmpty else {
            throw UserAuthentcationError.emptyPass
        }
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            throw UserAuthentcationError.emptyConfirmPass
        }
        guard password == confirmPassword else {
            throw UserAuthentcationError.notTheSamePasswords
        }
        guard password.count >= minCount else {
            throw UserAuthentcationError.tooShortPass(count: minCount)
        }
        return password
    }
    
    @discardableResult
    static func validateLocation(lat: String?, lng: String?) throws  -> (lat: String, lng: String) {
        if let lat = lat, let lng = lng, !lat.isEmpty, !lng.isEmpty {
            return (lat: lat, lng: lng)
        } else {
            throw UserAuthentcationError.selectLocation
        }
    }
    
    enum UserAuthentcationError: ValidatorError {
        
        case invalidMail
        case invalidPhone
        
        case tooShortName
        case tooShortPass(count: Int)
        case tooShortPhone
        
        case emptyName
        case emptyPass
        case emptyConfirmPass
        case emptyMail
        case emptyPhone
        
        case notTheSamePasswords
        
        case selectLocation
        
        case emptyField(decription: String)
        case tooShortField(decription: String, count: Int)
        
        internal var associatedMessage: String {
            var message = "Error"
            
            switch self {
            case .invalidMail:
                message = "Enter Your Valid E-mail."
            case .tooShortName:
                message = "Enter Your Full Name, Must Be At Least 6 Chars."
            case .tooShortPass(let count):
                message = "\("Password Should Be At Least".localize) \(count) \("Chars".localize)."
            case .emptyName:
                message = "Empty Name."
            case .emptyPass:
                message = "Please Enter Your Password."
            case .emptyConfirmPass:
                message = "Please Confirm Your Password."
            case .emptyMail:
                message = "Empty Mail!"
            case .emptyField(let decription):
                message = "\("Please Enter Valid".localize) \(decription)"
            case .tooShortField(let decription, let count):
                message = "\("Please Enter Valid".localize) \(decription), \("Must Be At least".localize) \(count)."
            case .tooShortPhone:
                message = "Enter Your Valid Phone Number, Must Be At Least 6 Nums."
            case .emptyPhone:
                message = "Enter Your Valid Phone Number."
            case .invalidPhone:
                message = "Your Phone Number Is Invalid."
            case .notTheSamePasswords:
                message = "Enter The Same Passord Twice."
            case .selectLocation:
                message = "Please Select Your Location."
            }
            return message.localize
        }
    }
}

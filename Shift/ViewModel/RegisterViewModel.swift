//
//  RegisterViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/12/2021.
//

import Foundation


final class RegisterViewModel: ObservableObject {
    
    
    enum result: String {
        case email = "Error: Wrong email format"
        case different = "Error: Passwords are different"
        case short = "Error: Password is too short"
//        case letterCase = "Error: Password has to contain lower AND upper cased characters"
        case good = ""
    }
    
    static func check(password password1: String, with password2: String, email: String) -> result {
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        let result = email.range(
            of: emailPattern,
            options: .regularExpression
        )

        let validEmail = (result != nil)
            
        if !validEmail {
            return .email
        }
        
        if password1 != password2 {
            return .different
        }
        if password1.count < 8 {
            return .short
        }
//        if password1.uppercased() != password1 {
//            return .letterCase
//        }
//        if password1.lowercased() != password1 {
//            return .letterCase
//        }
        return .good
    }
    
    func createUser(_ user: User, email: String, password: String) {
        WebService.shared.createUser(user, email: email, password: password)
    }
}

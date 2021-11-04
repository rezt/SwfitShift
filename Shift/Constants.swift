//
//  Constants.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/10/2021.
//

import Foundation

struct K {
    static let appName = "Swift Shift"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToSwiftShift"
    
//    struct BrandColors {
//        static let purple = "BrandPurple"
//        static let lightPurple = "BrandLightPurple"
//        static let blue = "BrandBlue"
//        static let lighBlue = "BrandLightBlue"
//    }
    
    struct FStore {
        static let collectionNameShifts = "shifts"
        static let collectionNameEmployees = "employees"
        static let employeeField = "employee"
        static let startField = "startDate"
        static let endField = "endDate"
        static let roleField = "role"
    }
    
    struct calendar {
        static let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        static let buttonPrevious = "chevron.left"
        static let buttonNext = "chevron.right"
    }

}

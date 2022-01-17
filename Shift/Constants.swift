//
//  Constants.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/10/2021.
//

import Foundation

struct K {
    static let appName = "Swift Shift"
    
    struct FStore {
        struct Shifts {
            static let collection = "shifts"
            static let employee = "employee"
            static let start = "startDate"
            static let end = "endDate"
            static let role = "role"
            static let state = "upForGrabs"
        }
        struct Employees {
            static let collection = "employees"
            static let login = "login"
            static let name = "name"
            static let role = "role"
            static let uid = "uid"
            static let roles = ["Admin", "Manager", "Cashier"]
        }
        struct Tasks {
            static let collection = "tasks"
            static let deadline = "deadline"
            static let description = "description"
            static let status = "status"
            static let team = "team"
            static let title = "title"
            static let states = ["To do", "In progress", "Done"]
        }
        struct Disposition {
            static let collection = "disposition"
            static let date = "date"
            static let available = "available"
            static let notPreferred = "notPreferred"
            static let unavailable = "unavailable"
            static let unknown = "unknown"
        }
        struct Presets {
            static let collection = "presets"
            static let start = "startDate"
            static let end = "endDate"
            static let name = "name"
        }
    }
    
    struct calendar {
        static let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        static let buttonPrevious = "chevron.left"
        static let buttonNext = "chevron.right"
    }

}

//
//  Shift.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/10/2021.
//

import Foundation
import FirebaseFirestore

struct Shift: Hashable {
    let employee: String
    let endDate: Timestamp
    let role: String
    let startDate: Timestamp
    let upForGrabs: Bool
    let FSID: String
    
    func getEndDate() -> Date {
        return endDate.dateValue()
    }
    
    func getStartDate() -> Date {
        return startDate.dateValue()
    }
    
    func getEndDateTime() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm"
        let date = formatter.string(from: endDate.dateValue())
        return date.components(separatedBy: " ")
    }
    
    func getStartDateTime() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm"
        let date = formatter.string(from: startDate.dateValue())
        return date.components(separatedBy: " ")
    }
    
}

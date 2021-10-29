//
//  Shift.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/10/2021.
//

import Foundation
import FirebaseFirestore

struct Shift {
    let employee: String
    let endDate: Timestamp
    let role: String
    let startDate: Timestamp
    
    func getEndDate() -> Date {
        return endDate.dateValue()
    }
    
    func getStartDate() -> Date {
        return startDate.dateValue()
    }
}

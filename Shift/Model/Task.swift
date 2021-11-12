//
//  Task.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import FirebaseFirestore

struct Task {
    let deadline: Timestamp
    let description: String
    let status: String
    let team: String
    
    func getDeadline() -> Date {
        return deadline.dateValue()
    }
}

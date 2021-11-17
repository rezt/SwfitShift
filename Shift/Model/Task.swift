//
//  Task.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import FirebaseFirestore

struct Task: Hashable {
    let deadline: Timestamp
    let description: String
    let status: String
    let team: String
    let title: String
    let FSID: String
    
    func getDeadline() -> Date {
        return deadline.dateValue()
    }
}

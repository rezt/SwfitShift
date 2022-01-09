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
    
    func getDeadlineFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = formatter.string(from: deadline.dateValue())
        return date
    }
}

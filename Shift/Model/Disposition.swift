//
//  Disposition.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import FirebaseFirestore

struct Disposition: Identifiable {
    var id = UUID().uuidString
    let date: Timestamp
    let available: [String]
    let notPreferred: [String]
    let unavailable: [String]
    let unknown: [String]
    let FSID: String
    
    func getDate() -> Date {
        return date.dateValue()
    }
    
    func getDateStart() -> Date {
        let date = date.dateValue()
        let result = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        return result!
    }
}

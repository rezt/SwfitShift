//
//  Disposition.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import FirebaseFirestore

struct Disposition: Hashable {
    let date: Timestamp
    let available: [String]
    let notPreferred: [String]
    let unavailable: [String]
    let unknown: [String]
    
    func getDate() -> Date {
        return date.dateValue()
    }
}

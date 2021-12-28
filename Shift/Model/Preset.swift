//
//  Preset.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 27/12/2021.
//

import Foundation
import Firebase

struct Preset {
    let startDate: Timestamp
    let endDate: Timestamp
    let name: String
    
    
    func getStartDateTime() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm"
        let date = formatter.string(from: startDate.dateValue())
        return date.components(separatedBy: " ")
    }
    
    func getEndDateTime() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH mm"
        let date = formatter.string(from: endDate.dateValue())
        return date.components(separatedBy: " ")
    }
    
}

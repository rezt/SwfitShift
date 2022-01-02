//
//  Preset.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 27/12/2021.
//

import Foundation
import Firebase

struct Preset: Hashable {
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
    
    func getEndDate() -> Date {
        return endDate.dateValue()
    }
    
    func getStartDate() -> Date {
        return startDate.dateValue()
    }
    
    func getEndTime(currentDate: Date) -> Date {
        let date = endDate.dateValue()
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        let result = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate)
        return result!
    }
    
    func getStartTime(currentDate: Date) -> Date {
        let date = startDate.dateValue()
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        print("hours: \(hour) minutes: \(minute)")
        let result = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate)
        return result!
    }
    
}

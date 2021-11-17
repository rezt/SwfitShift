//
//  CalendarViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 25/10/2021.
//

import Foundation
import Firebase
import SwiftUI

final class CalendarViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var shifts: [Shift] = []
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    var assignedShifts: [Shift] = []
    
    init() {
        loadShifts()
    }
    
    func getShifts() -> [Shift] {
        return shifts
    }
    
    func getShiftsFor(employeeID: String) -> [Shift] {
        shifts.forEach { shift in
            if employeeID == shift.employee {
                assignedShifts.append(shift)
            }
        }
        return assignedShifts
    }
    
    func loadShifts() {
        db.collection(K.FStore.Shifts.collection).addSnapshotListener { (querySnapshot, error) in
            self.shifts = []
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let employee = data[K.FStore.Shifts.employee] as? String,
                           let endDate = data[K.FStore.Shifts.end] as? Timestamp,
                           let role = data[K.FStore.Shifts.role] as? String,
                           let startDate = data[K.FStore.Shifts.start] as? Timestamp,
                           let state = data[K.FStore.Shifts.state] as? Bool {
                            let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate, upForGrabs: state, FSID: doc.documentID)
                            self.shifts.append(newShift)
                            DispatchQueue.main.async {
                                self.printShifts()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func changeStateOfShift(_ shift: Shift) {
        let shiftRef = db.collection(K.FStore.Shifts.collection).document(shift.FSID)
        
        shiftRef.updateData([
            "upForGrabs": !shift.upForGrabs
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func printShifts() {
        print(shifts.count)
        print(shifts)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // TODO: Collapse these two into one function:
    
    func getYearMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getDay() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d yyyy"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func getDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day , date: date)
        }
        
        
        // Move sunday to be the last day of th week
        var firstWeekday = calendar.component(.weekday, from: days.first!.date)
        print(firstWeekday)
        firstWeekday -= 1
        if firstWeekday == 0 {
            firstWeekday = 7
        }
        
        // Add "empty" days to match weekday
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        
        return days
    }
}

extension Date{
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        // Get starting date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}




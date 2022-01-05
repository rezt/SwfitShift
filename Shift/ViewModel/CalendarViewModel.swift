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

    @Published var shifts: [Shift] = []
    @Published var employees: [User] = []
    var currentUser = User(login: "", name: "", role: "", uid: "", FSID: "")
    var shiftViewModel = ShiftViewModel(withShift: Shift(employee: "", endDate: Timestamp(date: Date()), role: "", startDate: Timestamp(date: Date()), upForGrabs: false, FSID: ""), withEmployees: [], canEdit: false)
    @Published var showShift: Bool = false
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var canEdit: Bool = false
    
    func update(_ user: User) {
        self.currentUser = user
    }
    
    func setEmployees(_ users: [User]) {
        employees = users
    }
    
    func getShifts() -> [Shift] {
        return shifts
    }
    
    func saveShift(_ newShift: Shift) {
        WebService.shared.saveShift(newShift)
    }
    
    func deleteShift(_ shift: Shift) {
        WebService.shared.deleteShift(shift)
    }
    
    func loadShifts(){
        print(currentUser.role)
        WebService.shared.loadShifts(role: currentUser.role, uid: currentUser.uid) { result in
            self.shifts = result!
        }
    }
    
    func changeStateOfShift(_ shift: Shift) {
        WebService.shared.changeStateOfShift(shift)
    }
    
    func takeShift(_ shift: Shift) {
        WebService.shared.takeShift(uid: currentUser.uid, shift: shift)
    }
    
    func enter(shift: Shift) {
        var canEdit = false
        if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[1] {
            canEdit = true
            print("canedit")
        }
        self.shiftViewModel = ShiftViewModel(withShift: shift, withEmployees: employees,canEdit: canEdit)
        showShift = true
    }
    
    func enterNew(userRole role: String) {
        self.shiftViewModel = ShiftViewModel(withShift: Shift(employee: "", endDate: Timestamp(date: Date()), role: role, startDate: Timestamp(date: Date()), upForGrabs: false, FSID: ""), withEmployees: employees, canEdit: true)
        self.showShift = true
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
    
    func getDate()->[DateValue] {
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day , date: date)
        }
        
        
        // Move sunday to be the last day of th week
        var firstWeekday = calendar.component(.weekday, from: days.first!.date)
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




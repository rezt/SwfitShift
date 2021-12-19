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
    
    @ObservedObject var auth: LoginViewModel
    @Published var shifts: [Shift] = []
    var shiftViewModel = ShiftViewModel(withShift: Shift(employee: "", endDate: Timestamp(date: Date()), role: "", startDate: Timestamp(date: Date()), upForGrabs: false, FSID: ""), canEdit: false)
    @Published var showShift: Bool = false
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var canEdit: Bool = false
    typealias LoadShiftsRoleClosure = (Array<Shift>?) -> Void
    
    init() {
        auth = LoginViewModel()
    }
    
    func setAuth(with auth: LoginViewModel) {
        self.auth = auth
    }
    
    func getShifts() -> [Shift] {
        return shifts
    }
    
    func saveShift(_ newShift: Shift) {
        if newShift.FSID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.Shifts.collection).addDocument(data: [
                K.FStore.Shifts.employee: newShift.employee,
                K.FStore.Shifts.role: newShift.role,
                K.FStore.Shifts.state: newShift.upForGrabs,
                K.FStore.Shifts.start: newShift.startDate,
                K.FStore.Shifts.end: newShift.endDate
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            db.collection(K.FStore.Shifts.collection).document(newShift.FSID).setData([
                K.FStore.Shifts.employee: newShift.employee,
                K.FStore.Shifts.role: newShift.role,
                K.FStore.Shifts.state: newShift.upForGrabs,
                K.FStore.Shifts.start: newShift.startDate,
                K.FStore.Shifts.end: newShift.endDate
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
            
        }
    }
    
    func deleteShift(_ shift: Shift) {
        db.collection(K.FStore.Shifts.collection).document(shift.FSID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func loadShifts(){
        if auth.user.role == K.FStore.Employees.roles[0] {
            loadShiftsAdmin()
        } else {
            loadShiftsNormal()
        }
    }
    
    func loadShiftsAdmin() { // Load all shifts
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
                            self.shifts.append(newShift)                        }
                    }
                }
            }
        }
    }
    
    func loadShiftsNormal() { // Load only shifts specified to user or user's role
        db.collection(K.FStore.Shifts.collection).whereField(K.FStore.Shifts.employee, isEqualTo: self.auth.user.uid).addSnapshotListener { (querySnapshot, error) in
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
                                self.loadShiftsRole { result in
                                    if result != nil {
                                        self.shifts = Array(Set(self.shifts).union(result!))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadShiftsRole(completionHandler: @escaping LoadShiftsRoleClosure) {
        db.collection(K.FStore.Shifts.collection).whereField(K.FStore.Shifts.state, isEqualTo: true).whereField(K.FStore.Shifts.role, isEqualTo: auth.user.role).addSnapshotListener { (querySnapshot, error) in
            var result = [Shift]()
            
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
                            result.append(newShift)
                            DispatchQueue.main.async {
                                if result.isEmpty {
                                    completionHandler(nil)
                                } else {
                                    completionHandler(result)
                                }
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
    
    func takeShift(_ shift: Shift) {
        let shiftRef = db.collection(K.FStore.Shifts.collection).document(shift.FSID)
        
        shiftRef.updateData([
            "employee": auth.user.uid,
            "upForGrabs": !shift.upForGrabs
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func enter(shift: Shift) {
        var canEdit = false
        if auth.user.role == K.FStore.Employees.roles[0] || auth.user.role == K.FStore.Employees.roles[1] {
            canEdit = true
            print("canedit")
        }
        self.shiftViewModel = ShiftViewModel(withShift: shift, canEdit: canEdit)
        showShift = true
    }
    
    func enterNew(userRole role: String) {
        self.shiftViewModel = ShiftViewModel(withShift: Shift(employee: "", endDate: Timestamp(date: Date()), role: role, startDate: Timestamp(date: Date()), upForGrabs: false, FSID: ""), canEdit: true)
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




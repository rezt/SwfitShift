//
//  DispositionViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import Firebase
import SwiftUI

final class DispositionViewModel: ObservableObject {
    
    @Published var employees: [User] = []
    @Published var thisMonth: [Disposition] = []
    @Published var userDisposition: [PersonalDisposition] = []
    @Published var isManager: Bool = false
    
    init() {
        if UserService.shared.currentUser.role == K.FStore.Employees.roles[0] || UserService.shared.currentUser.role == K.FStore.Employees.roles[1] {
            isManager = true
        }
    }
    
    func setEmployees(_ users: [User]) {
        employees = users
    }
    
    func loadEmployees() {
        WebService.shared.loadEmployees() { result in
            if result != nil {
                self.employees = result!
            }
        }
    }
    
    func loadDisposition() {
        WebService.shared.loadDisposition() { result in
            self.thisMonth = result!
            self.userDisposition = []
            self.getPersonalDisposition()
        }
    }
    
    func detachEmployees() {
        WebService.shared.detachListener(WebService.shared.employeeListener)
    }
    
    func detachDispostion() {
        WebService.shared.detachListener(WebService.shared.dispositionListener)
    }
    
    func getDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: date)
        return date.description
    }
    
    func generateDisposition() {
        var i = 0
        var lastDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        if thisMonth.count != 0 {
            lastDate = (thisMonth.last?.getDate())!
            let futureDate = Calendar.current.date(byAdding: .day, value: 30, to: Date())
            let calendar = Calendar.current
            i = calendar.numberOfDaysBetween(lastDate, and: futureDate!)
        } else {
            i = 31
        }
        
        var uids: [String] = []
        for employee in employees {
            uids.append(employee.uid)
        }

        for _ in 0..<i {
            
            WebService.shared.generateDisposition(lastDate: lastDate, uids: uids)
            
            lastDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
        }
    }
    
    func modifyDisposition(_ newDisposition: PersonalDisposition) {
        
        let dispo = thisMonth.first { dispo in
            dispo.FSID == newDisposition.FSID
        }
        if dispo == nil {
            print("Error while finding dispositionObject")
            return
        }
        var newAvailable = dispo!.available.filter { $0 != UserService.shared.currentUser.uid }
        var newNotPreferred = dispo!.notPreferred.filter { $0 != UserService.shared.currentUser.uid }
        var newUnavailable = dispo!.unavailable.filter { $0 != UserService.shared.currentUser.uid }
        var newUnknown = dispo!.unknown.filter { $0 != UserService.shared.currentUser.uid }
        if newDisposition.value[0] {
            newAvailable.append(UserService.shared.currentUser.uid)
        } else if newDisposition.value[1] {
            newNotPreferred.append(UserService.shared.currentUser.uid)
        } else if newDisposition.value[2] {
            newUnavailable.append(UserService.shared.currentUser.uid)
        } else {
            newUnknown.append(UserService.shared.currentUser.uid)
        }
        
        let newDispo = Disposition(date: dispo!.date, available: newAvailable, notPreferred: newNotPreferred, unavailable: newUnavailable, unknown: newUnknown, FSID: newDisposition.FSID)
        
        WebService.shared.modifyDisposition(newDispo: newDispo, FSID: newDisposition.FSID)
    }
    
    func cleanup() {
        var validUID: [String] = []
        
        for user in employees {
            validUID.append(user.uid)
        }
        
        for day in thisMonth {
            let newAvailable = day.available.filter {
                validUID.contains($0)
            }
            let newNotPreferred = day.notPreferred.filter {
                validUID.contains($0)
            }
            let newUnavailable = day.unavailable.filter {
                validUID.contains($0)
            }
            let newUnknown = day.unknown.filter {
                validUID.contains($0)
            }
            
            WebService.shared.cleanup(day: day, newAvailable: newAvailable, newNotPreferred: newNotPreferred, newUnavailable: newUnavailable, newUnknown: newUnknown)
        }
    }
    
    func getPersonalDisposition() {
        for dispo in thisMonth {
            if dispo.available.contains(UserService.shared.currentUser.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [true,false,false,false], FSID: dispo.FSID))
            } else if dispo.notPreferred.contains(UserService.shared.currentUser.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,true,false,false], FSID: dispo.FSID))
            } else if dispo.unavailable.contains(UserService.shared.currentUser.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,true,false], FSID: dispo.FSID))
            } else {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,false,true], FSID: dispo.FSID))
            }
        }
    }
    
    func printDispo() {
        print(thisMonth)
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day!
    }
}

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
    
    let db = Firestore.firestore()
    @ObservedObject var auth: LoginViewModel
    @Published var thisMonth: [Disposition] = []
    @Published var userDisposition: [PersonalDisposition] = []
    @Published var isManager: Bool = false
    var presets: [Preset] = []
    
    init() {
        auth = LoginViewModel()
        if auth.user.role == K.FStore.Employees.roles[0] || auth.user.role == K.FStore.Employees.roles[1] {
            isManager = true
            print("isManager")
        }
    }
    
    func setAuth(with auth: LoginViewModel) {
        self.auth = auth
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
        for employee in auth.employees {
            uids.append(employee.uid)
        }

        for _ in 0..<i {
            var ref: DocumentReference? = nil
            ref = db.collection(K.FStore.Disposition.collection).addDocument(data: [
                K.FStore.Disposition.date: Timestamp(date: lastDate),
                K.FStore.Disposition.available: [""],
                K.FStore.Disposition.notPreferred: [""],
                K.FStore.Disposition.unavailable: [""],
                K.FStore.Disposition.unknown: uids
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
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
        var newAvailable = dispo!.available.filter { $0 != auth.user.uid }
        var newNotPreferred = dispo!.notPreferred.filter { $0 != auth.user.uid }
        var newUnavailable = dispo!.unavailable.filter { $0 != auth.user.uid }
        var newUnknown = dispo!.unknown.filter { $0 != auth.user.uid }
        if newDisposition.value[0] {
            newAvailable.append(auth.user.uid)
        } else if newDisposition.value[1] {
            newNotPreferred.append(auth.user.uid)
        } else if newDisposition.value[2] {
            newUnavailable.append(auth.user.uid)
        } else {
            newUnknown.append(auth.user.uid)
        }
        
        let newDispo = Disposition(date: dispo!.date, available: newAvailable, notPreferred: newNotPreferred, unavailable: newUnavailable, unknown: newUnknown, FSID: newDisposition.FSID)
        
        db.collection(K.FStore.Disposition.collection).document(newDisposition.FSID).setData([
            K.FStore.Disposition.date: newDispo.date,
            K.FStore.Disposition.available: newDispo.available,
            K.FStore.Disposition.notPreferred: newDispo.notPreferred,
            K.FStore.Disposition.unavailable: newDispo.unavailable,
            K.FStore.Disposition.unknown: newDispo.unknown
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func getPersonalDisposition() {
        for dispo in thisMonth {
            if dispo.available.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [true,false,false,false], FSID: dispo.FSID))
            } else if dispo.notPreferred.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,true,false,false], FSID: dispo.FSID))
            } else if dispo.unavailable.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,true,false], FSID: dispo.FSID))
            } else {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,false,true], FSID: dispo.FSID))
            }
        }
    }
    
    func loadDisposition() { // Load only shifts specified to user or user's role
        
        let futureDate = Calendar.current.date(byAdding: .day, value: 31, to: Date())
        
        db.collection(K.FStore.Disposition.collection).whereField("date", isGreaterThanOrEqualTo: Date()).whereField("date", isLessThanOrEqualTo: futureDate!).addSnapshotListener { (querySnapshot, error) in
            self.thisMonth = []
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let available = data[K.FStore.Disposition.available] as? [String],
                           let notPreferred = data[K.FStore.Disposition.notPreferred] as? [String],
                           let unavailable = data[K.FStore.Disposition.unavailable] as? [String],
                           let unknown = data[K.FStore.Disposition.unknown] as? [String],
                           let date = data[K.FStore.Disposition.date] as? Timestamp {
                            let newDisposition = Disposition(date: date, available: available, notPreferred: notPreferred, unavailable: unavailable, unknown: unknown, FSID: doc.documentID)
                            self.thisMonth.append(newDisposition)
                            DispatchQueue.main.async {
//                                self.printDispo()
                                self.userDisposition = []
                                self.getPersonalDisposition()
                            }
                            
                            
//                            DispatchQueue.main.async {
//                                self.loadShiftsRole { result in
//                                    if result != nil {
//                                        self.thisMonth = Array(Set(self.shifts).union(result!))
//                                    }
//                                }
//                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadPresets() {
        db.collection(K.FStore.Presets.collection).addSnapshotListener { (querySnapshot, error) in
            self.presets = []
            
            if let e = error {
                print("There was an issue retriving preset data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let startDate = data[K.FStore.Presets.start] as? Timestamp,
                           let endDate = data[K.FStore.Presets.end] as? Timestamp,
                           let name = data[K.FStore.Presets.name] as? String {
                            let newPreset = Preset(startDate: startDate, endDate: endDate, name: name)
                            self.presets.append(newPreset)
                        }
                    }
                }
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

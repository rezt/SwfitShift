//
//  CalendarViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 25/10/2021.
//

import Foundation
import Firebase
import SwiftUI

extension CalendarView {
    class CalendarViewModel: ObservableObject {
        
        let db = Firestore.firestore()
        
        @Published var shifts: [Shift] = []
        var assignedShifts: [Shift] = []
        
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
            db.collection(K.FStore.collectionNameShifts).addSnapshotListener { (querySnapshot, error) in
                self.shifts = []
                
                if let e = error {
                    print("There was an issue retriving date from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let employee = data[K.FStore.employeeField] as? String, let endDate = data[K.FStore.endField] as? Timestamp, let role = data[K.FStore.roleField] as? String, let startDate = data[K.FStore.startField] as? Timestamp, let state = data[K.FStore.stateField] as? Bool {
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
            let shiftRef = db.collection(K.FStore.collectionNameShifts).document(shift.FSID)
            
            // Set the "capital" field of the city 'DC'
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
            print(shifts[0].employee)
            print(shifts[0].getStartDate())
            print(shifts[0].getEndDate())
            print(shifts[0].role)
            print(shifts)
        }
        
    }
    
}


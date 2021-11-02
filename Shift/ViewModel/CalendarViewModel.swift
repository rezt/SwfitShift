//
//  CalendarViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 25/10/2021.
//

import Foundation
import Firebase

extension CalendarView {
    class CalendarViewModel {
        
        let db = Firestore.firestore()
        
        var shifts: [Shift] = []
        
        func getShifts() -> [Shift] {
            return shifts
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
                            if let employee = data[K.FStore.employeeField] as? String, let endDate = data[K.FStore.endField] as? Timestamp, let role = data[K.FStore.roleField] as? String, let startDate = data[K.FStore.startField] as? Timestamp {
                                let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate)
                                self.shifts.append(newShift)
                                DispatchQueue.main.async {
                                    self.printShifts()
                                }
                            }
                        }
                    }
                }
            }
            
//            let docRef = db.collection(K.FStore.collectionNameShifts).document("wUt3hH1MUbbaOYvelz5V")
//
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                    let data = document.data()
//                    if let employee = data![K.FStore.employeeField] as? String, let endDate = data![K.FStore.endField] as? Timestamp, let role = data![K.FStore.roleField] as? String, let startDate = data![K.FStore.startField] as? Timestamp {
//                        let newShift = Shift(employee: employee, endDate: endDate, role: role, startDate: startDate)
//                        self.shifts.append(newShift)
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
        }
        
        func printShifts() {
            print(shifts.count)
                        print(shifts[0].employee)
                        print(shifts[0].getStartDate())
                        print(shifts[0].getEndDate())
                        print(shifts[0].role)
        }
        
    }
    
}


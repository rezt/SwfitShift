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
    
    init() {
        auth = LoginViewModel()
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
    
    func getPersonalDisposition() {
        for dispo in thisMonth {
            if dispo.available.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [true,false,false,false]))
            } else if dispo.notPreferred.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,true,false,false]))
            } else if dispo.unavailable.contains(auth.user.uid) {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,true,false]))
            } else {
                userDisposition.append(PersonalDisposition(date: dispo.getDate(), value: [false,false,false,true]))
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
                            let newDisposition = Disposition(date: date, available: available, notPreferred: notPreferred, unavailable: unavailable, unknown: unknown)
                            self.thisMonth.append(newDisposition)
                            DispatchQueue.main.async {
                                self.printDispo()
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
    
    
    func printDispo() {
        print(thisMonth)
    }
}

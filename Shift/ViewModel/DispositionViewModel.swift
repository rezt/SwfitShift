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
    
    init() {
        auth = LoginViewModel()
    }
    
    func setAuth(with auth: LoginViewModel) {
        self.auth = auth
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

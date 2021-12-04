//
//  LoginViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 17/10/2021.
//

import Foundation
import Firebase


class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var user = User(login: "", name: "", role: "", uid: "")
    @Published var employees = [User]()
    let db = Firestore.firestore()
    let task = DispatchGroup()
    let task2 = DispatchGroup()
    
    typealias GetDetailsClosure = (Array<User>?) -> Void
    
    func login(withEmail email: String, withPassword password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.user = User(login: "", name: "", role: "", uid: Auth.auth().currentUser!.uid)
                self.getDetails(forUserID: self.user.uid) { result in
                    if result != nil {
                        self.user = result![0]
                        self.employees.append(self.user)
                        self.isLoggedIn = true
                    }
                }
            }
        }
    }
    
    
    func getDetails(forUserID userID: String, completionHandler: @escaping GetDetailsClosure) {
        let docRef = db.collection(K.FStore.Employees.collection).whereField(K.FStore.Employees.uid, isEqualTo: userID)
        
        var result = [User]()
        
        docRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Document does not exist \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let login = data[K.FStore.Employees.login] as? String,
                       let name = data[K.FStore.Employees.name] as? String,
                       let role = data[K.FStore.Employees.role] as? String,
                       let uid = data[K.FStore.Employees.uid] as? String {
                        result.append(User(login: login, name: name, role: role, uid: uid))
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
    
    func loadEmployees(withRole role: String) {
        db.collection(K.FStore.Employees.collection).whereField(K.FStore.Employees.role, isEqualTo: role).addSnapshotListener { (querySnapshot, error) in
            self.employees = []
            
            if let e = error {
                print("There was an issue retriving shift data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        print("getting employee")
                        let data = doc.data()
                        if let login = data[K.FStore.Employees.login] as? String,
                           let name = data[K.FStore.Employees.name] as? String,
                           let role = data[K.FStore.Employees.role] as? String,
                           let uid = data[K.FStore.Employees.uid] as? String {
                            let nextEmployee = User(login: login, name: name, role: role, uid: uid)
                            self.employees.append(nextEmployee)
                        }
                    }
                }
            }
        }
    }
    
    func printEmployees() {
        print(self.employees.count)
    }
    
    
}
